//
//  UserInfoService.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import CryptoKit
import Foundation
import SwiftECC

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
    var timestamp: Int = AppUtils.currentTime() // TODO: hardcode
    var generator: OCRABuilderInterface?
    let keychain = KeychainItem()

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
        
        timestamp = AppUtils.currentTime()
        generator = OCRAGenerator()
            .accept(suite: ocraSuite, key: sharedKey)
            .params(counter: ocraCounter, question: question, password: pinOtp)
            .sessionWith(sessionInfo: sessionInfo, timestamp: timestamp)
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
            fatalError("User's data not found: \(msisdn)")
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
        let domain = Domain.instance(curve: .EC256r1)
        let (publicKey, privateKey): (ECPublicKey, ECPrivateKey) = domain.makeKeyPair()
        var userData: UserInfo
        guard let userData = try? keychain.readData(by: msisdn) else {
            fatalError("User's data not found: \(msisdn)")
        }
        userData.publicKey = publicKey.der.hexaAsString
        userData.privateKey = privateKey.derPkcs8.hexaAsString
        guard (try? keychain.saveData(of: userData)) != nil else { return nil }
        return publicKey.der
    }

    func getShared(by user: UserInfo) -> String? {
        let info: Bytes = []
        guard let privateKey = user.privateKey?.hexaBytes, let serverPublicKey = user.serverPublicKey?.hexaBytes,
              let userPrivateECCKey = try? ECPrivateKey(der: privateKey, pkcs8: true),
              let serverPublicECCKey = try? ECPublicKey(der: serverPublicKey) else { return nil }
        let secretKey = try? userPrivateECCKey.keyAgreement(pubKey: serverPublicECCKey, length: getSeedLenght(), md: .SHA2_256, sharedInfo: info)
        return secretKey?.hexaAsString
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
