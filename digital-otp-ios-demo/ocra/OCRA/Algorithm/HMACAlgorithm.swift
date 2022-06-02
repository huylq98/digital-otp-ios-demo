//
//  HMACAlgorithm.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation

protocol HMACAlgorithmType {
    var digestLength: Int { get }
    var algorithm: CCHmacAlgorithm { get }
}

extension HMACAlgorithmType {
    func encode(key: [UInt8], message: [UInt8], result: UnsafeMutablePointer<CUnsignedChar>) -> [UInt8] {
        let digestLen = digestLength
        CCHmac(algorithm, key, key.count, message, message.count, result)
        let hmac = stringFromResult(result: result, length: digestLen).hexaBytes
        return hmac
    }

    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
}

struct HMACAlgorithmSHA1: HMACAlgorithmType {
    static let identifier = "sha1"
    var digestLength: Int = .init(CC_SHA1_DIGEST_LENGTH)
    var algorithm: CCHmacAlgorithm = .init(kCCHmacAlgSHA1)
}

struct HMACAlgorithmSHA256: HMACAlgorithmType {
    static let identifier = "sha256"
    var digestLength: Int = .init(CC_SHA256_DIGEST_LENGTH)
    var algorithm: CCHmacAlgorithm = .init(kCCHmacAlgSHA256)
}

struct HMACAlgorithmSHA512: HMACAlgorithmType {
    static let identifier = "sha512"
    var digestLength: Int = .init(CC_SHA512_DIGEST_LENGTH)
    var algorithm: CCHmacAlgorithm = .init(kCCHmacAlgSHA512)
}
