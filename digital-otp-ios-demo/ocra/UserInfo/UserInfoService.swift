//
//  UserInfoService.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import CryptoKit
import Foundation

protocol UserInfoServiceAPI {
    // Map<String, String> generateOTP(Context context, String msisdn, String question, String pinOtp)
    // TODO: Check time
    func generateOTP(msisdn: String, question: String, pinOtp: String) -> String?

    // void saveKeys(Context context, String msisdn, String publicKey, long syncTime
    func saveKeys(msisdn: String, serverPublicKey: String, syncTime: Int)

    // void syncTime(Context context, String msisdn, long syncTime)
    func syncTime(msisdn: String, syncTime: Int)

    // byte[] generatePublicECKey(Context context, String msisdn)
    func generatePublicECKey(msisdn: String, force: Bool) -> [UInt8]?

    func getShared(by user: UserInfo) -> String?
}

class UserInfoService: UserInfoServiceAPI {
    let ocraSuite: String = AppConfig.shared.ocraSuite // TODO: hardcode
    let ocraCounter: String = "" // TODO: hardcode
    let sessionInfo: String = "" // TODO: hardcode
    var generator: OCRABuilderInterface?
    let keychain = KeychainItem()
    
    private init(){}
    static let shared: UserInfoServiceAPI = UserInfoService()

    func generateOTP(msisdn: String, question: String, pinOtp: String) -> String? {
        var user: UserInfo
        do {
            user = try keychain.readData(by: msisdn)
        } catch {
            return nil
        }

        var sharedKey: String?
        if #available(iOS 14.0, *) {
            sharedKey = getSharedNative(by: user)
        } else {
            sharedKey = getShared(by: user)
        }
        guard let sharedKey = sharedKey else { return nil }

        print("sharedKey = \(sharedKey)")
        let timeStamp = AppUtils.currentTime() // TODO: + user.syncTime
        print("timeStamp = \(timeStamp)")
        
        // 3308980042285
        generator = OCRAGenerator()
            .accept(suite: ocraSuite, key: sharedKey)
            .params(counter: ocraCounter, question: question, password: pinOtp)
            .sessionWith(sessionInfo: sessionInfo, timestamp: timeStamp)
        return generator?.generateOTP()
    }

    func saveKeys(msisdn: String, serverPublicKey: String, syncTime: Int) {
        guard let userData = try? keychain.readData(by: msisdn) else {
            fatalError("User's data not found: \(msisdn)")
        }
        userData.serverPublicKey = serverPublicKey
        userData.syncTime = syncTime
        try? keychain.saveData(of: userData)
    }

    func syncTime(msisdn: String, syncTime: Int) {
        guard let userData = try? keychain.readData(by: msisdn) else {
            return
        }
        userData.syncTime = syncTime
        try? keychain.saveData(of: userData)
    }

    func generatePublicECKey(msisdn: String, force: Bool = false) -> [UInt8]? {
        if force {
            return generateKeyPair(saveId: msisdn)
        }

        if let exitData = try? keychain.readData(by: msisdn), let publicKey = exitData.publicKey {
            return publicKey.hexaBytes
        }

        return generateKeyPair(saveId: msisdn)
    }

    func generateKeyPair(saveId msisdn: String) -> [UInt8]? {
        var privateKeyData: Data?
        var publicKeyHexString: String?

        if #available(iOS 14.0, *) {
            let privateKey = P256.KeyAgreement.PrivateKey()
            let publicKey = privateKey.publicKey
            privateKeyData = privateKey.derRepresentation
            publicKeyHexString = publicKey.derRepresentation.hexaAsString

        } else {
            var error: Unmanaged<CFError>?
            let keyPairAttr: [String: Any] = [kSecAttrKeySizeInBits as String: 256,
                                              SecKeyKeyExchangeParameter.requestedSize.rawValue as String: getSeedLenght(),
                                              kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                                              kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
                                              kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: false],
                                              kSecPublicKeyAttrs as String: [kSecAttrIsPermanent as String: false]]

            guard let privateKey = SecKeyCreateRandomKey(keyPairAttr as CFDictionary, &error),
                  let privateKeyAsData: Data = SecKeyCopyExternalRepresentation(privateKey, &error) as? Data,
                  let publicKey = SecKeyCopyPublicKey(privateKey), let publicKeyAsHexString = try? CodeableUtil.shared.convertSecKeyToDerKeyFormat(key: publicKey) else {
                return nil
            }

            privateKeyData = privateKeyAsData
            publicKeyHexString = publicKeyAsHexString
        }

        let userData = UserInfo(userId: msisdn)
        userData.publicKey = publicKeyHexString
        userData.privateKey = privateKeyData?.hexaAsString
        userData.syncTime = Int(Date().timeIntervalSince1970 * 1000)
        guard (try? keychain.saveData(of: userData)) != nil else { return nil }
        return userData.publicKey?.hexaBytes
    }

    func getShared(by user: UserInfo) -> String? {
        var error: Unmanaged<CFError>?
        let keyPairAttr: [String: Any] = [kSecAttrKeySizeInBits as String: 256,
                                          SecKeyKeyExchangeParameter.requestedSize.rawValue as String: getSeedLenght(),
                                          kSecAttrKeyType as String: kSecAttrKeyTypeEC,
                                          kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
                                          kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: false],
                                          kSecPublicKeyAttrs as String: [kSecAttrIsPermanent as String: false]]
        let algorithm = SecKeyAlgorithm.ecdhKeyExchangeStandard

        guard let privateKeyData = user.privateKey?.hexaData,
              let privateKey = SecKeyCreateWithData(privateKeyData as CFData, [
                  kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                  kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
              ] as CFDictionary, &error) else {
            return nil
        }

        let mutableData = CFDataCreateMutable(kCFAllocatorDefault, CFIndex(0))
        if mutableData != nil, let serverPublicData = user.serverPublicKey?.hexaData {
            CFDataAppendBytes(mutableData, CFDataGetBytePtr(serverPublicData as CFData), CFDataGetLength(serverPublicData as CFData))
            CFDataDeleteBytes(mutableData, CFRangeMake(CFIndex(0), 26))

            guard let serverPublicKey = SecKeyCreateWithData(mutableData! as CFData,
                                                             [kSecAttrKeyType as String: kSecAttrKeyTypeECSECPrimeRandom,
                                                              kSecAttrKeyClass as String: kSecAttrKeyClassPublic] as CFDictionary,
                                                             &error) else {
                return nil
            }

            let shared: CFData? = SecKeyCopyKeyExchangeResult(privateKey, algorithm, serverPublicKey, keyPairAttr as CFDictionary, &error)
            let sharedData: Data = shared! as Data
            return sharedData.hexaAsString
        }
        return nil
    }

    @available(iOS 14.0, *)
    func getSharedNative(by user: UserInfo) -> String? {
        guard let privateKey = user.privateKey?.hexaBytes, let serverPublicKey = user.serverPublicKey?.hexaBytes,
              let userPrivateKey = try? P256.KeyAgreement.PrivateKey(derRepresentation: privateKey),
              let serverPublicKey = try? P256.KeyAgreement.PublicKey(derRepresentation: serverPublicKey),
              let sharedKey = try? userPrivateKey.sharedSecretFromKeyAgreement(with: serverPublicKey) else { return nil }
        let sharedKeyAsHexaString = sharedKey.withUnsafeBytes { pointer in
            pointer.hexaAsString
        }
        return sharedKeyAsHexaString
    }

    private func getSeedLenght() -> Int {
        let elements = ocraSuite.split(separator: ":")
        if elements.count > 2 {
            let algorithm = elements[1]
            if algorithm.contains("SHA1") {
                return 20
            }
            if algorithm.contains("SHA256") {
                return 32
            }
            if algorithm.contains("SHA512") {
                return 64
            }
        }
        // Default
        return 32
    }
}
