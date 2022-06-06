//
//  OCRAGenerator.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation

public protocol OCRABuilderInterface {
    func accept(suite ocraSuite: String, key seed: String) -> OCRABuilderInterface // detect password algorithm password + question format
    func params(counter: String, question: String, password: String) -> OCRABuilderInterface // create passwordHex, questionHex
    func sessionWith(sessionInfo: String?, timestamp: Int?) -> OCRABuilderInterface // -> convert timestamp
    func generateOTP() -> String
}

public class OCRAGenerator: OCRABuilderInterface {
    var hmacAlgorithm: HMACAlgorithmType = HMACAlgorithmSHA1()
    var passwordAlgorithm: PasswordAlgorithmType?
    var questionFormat: QuestionFormatType?
    var counterFormat: CounterFormat?
    var sessionInformation: SessionInfomationType?
    var timestampFormat: TimestampFormat?

    var seed: String = ""
    var ocraSuite: String = ""
    var codeDigits: Int = 0

    var counterLength: Int { return counterFormat?.counterLength ?? 0 }
    var questionLength: Int { return questionFormat?.questionLength ?? 0 }
    var passwordLength: Int { return passwordAlgorithm?.passwordLength ?? 0 }
    var sessionInformationLength: Int { return sessionInformation?.sessionInformationLength ?? 0 }
    var timeStampLength: Int { return timestampFormat?.timeStampLength ?? 0 }

    var msg: [UInt8]!

    public init() {}

    public func accept(suite ocraSuite: String, key seed: String) -> OCRABuilderInterface {
        self.ocraSuite = ocraSuite
        self.seed = seed
        let elements = ocraSuite.components(separatedBy: ":")
        guard elements.count >= 3 else { fatalError("OCRA suite format is invalid!") }
        let cryptoFunction = elements[1]
        let dataInput = elements[2]

        hmacAlgorithm = AlgorithmFactory.shared.getHMACAlgorithm(by: cryptoFunction)
        passwordAlgorithm = AlgorithmFactory.shared.getPasswordAlgorithm(by: dataInput)
        questionFormat = AlgorithmFactory.shared.getQuestionFormat(by: dataInput)
        sessionInformation = AlgorithmFactory.shared.getSessionInformation(by: dataInput)

        if let refCodeDigits = Int(cryptoFunction.suffix(1)) {
            codeDigits = refCodeDigits
        }

        if dataInput.lowercased().first == CounterFormat.symbol { // "c"
            counterFormat = CounterFormat()
        }

        if let firstIndex = dataInput.lastIndex(of: TimestampFormat.identifier) { // "T"
            timestampFormat = TimestampFormat(String(dataInput[firstIndex...]))
        }

        let bufferSize: Int = ocraSuite.bytes.count + counterLength + questionLength + passwordLength + sessionInformationLength + timeStampLength + 1
        guard let msg = stringToUInt8Array(valor: ocraSuite, size: bufferSize) else { fatalError("Cannot initial message with suite: \(ocraSuite)") }
        self.msg = msg
        return self
    }

    public func params(counter: String, question: String, password: String) -> OCRABuilderInterface {
        guard msg != nil else { fatalError("You need to call accept() func with ocra suite first") }

        if let counterFormat = counterFormat {
            let counterAsHex = counterFormat.getHex(raw: counter)
            msg = arrayCopy(arrayFrom: counterAsHex.hexaBytes, arrayTo: msg, startIndex: ocraSuite.count + 1)
        }

        if let questionFormat = questionFormat {
            let questionAsHex = questionFormat.convert2Hex(raw: question)
            msg = arrayCopy(arrayFrom: questionAsHex.hexaBytes, arrayTo: msg, startIndex: ocraSuite.count + 1 + counterLength)
        }

        if let passwordAlgorithm = passwordAlgorithm {
            let hexPassword = passwordAlgorithm.getHexPassword(raw: password)
            msg = arrayCopy(arrayFrom: hexPassword.hexaBytes, arrayTo: msg, startIndex: ocraSuite.count + 1 + counterLength + questionLength)
        }
        return self
    }

    public func sessionWith(sessionInfo: String?, timestamp: Int?) -> OCRABuilderInterface {
        if let sessionInformation = sessionInformation, let sessionInfo = sessionInfo {
            let sessionInfoHex = sessionInformation.getHex(raw: sessionInfo)
            msg = arrayCopy(arrayFrom: sessionInfoHex.hexaBytes, arrayTo: msg, startIndex: ocraSuite.count + 1 + counterLength + questionLength + passwordLength)
        }

        if let timestampFormat = timestampFormat, let timestamp = timestamp {
            let timestampHex = timestampFormat.getHex(raw: timestamp)
            msg = arrayCopy(arrayFrom: timestampHex.hexaBytes, arrayTo: msg, startIndex: ocraSuite.count + 1 + counterLength + questionLength + passwordLength + sessionInformationLength)
        }
        return self
    }

    public func generateOTP() -> String {
        guard msg != nil else { fatalError("You need to call accept() func with ocra suite first") }

        var otp = ""
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: hmacAlgorithm.digestLength)
        let hmac = hmacAlgorithm.encode(key: seed.hexaBytes, message: msg, result: result)

        // Get offset
        let offset = Int((hmac.last ?? 0x00) & 0x0f)

        // Truncate HMAC into 32-bit integer (big-endian)
        let truncated = result.advanced(by: offset).withMemoryRebound(to: UInt32.self, capacity: MemoryLayout<UInt32>.size) { $0.pointee.bigEndian }

        // Discard most significant bit
        let discardedMSB = truncated & 0x7fffffff

        // Limit the number of digits
        let modulus = UInt32(pow(10, Float(codeDigits)))

        let stringValue = String(discardedMSB % modulus)

        // Create left padding if current digits count is not enough
        let paddingCount = Int(codeDigits) - stringValue.count

        result.deallocate()

        if paddingCount != 0 {
            otp = String(repeating: "0", count: paddingCount) + stringValue
        } else {
            otp = stringValue
        }

        return otp
    }

    private func arrayCopy(arrayFrom: [UInt8], arrayTo: [UInt8], startIndex: Int) -> [UInt8] {
        var bytes = arrayTo
        bytes[startIndex ..< startIndex + arrayFrom.count] = arrayFrom[0 ... arrayFrom.count - 1]
        return bytes
    }

    private func stringToUInt8Array(valor: String, size: Int) -> [UInt8]? {
        if let data = valor.data(using: .utf8) {
            var bytes = [UInt8](repeating: 0, count: size)
            data.copyBytes(to: &bytes, count: data.count)
            return bytes
        }
        return nil
    }
}
