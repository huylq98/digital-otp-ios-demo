//
//  PasswordHashAlgorithm.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation

protocol PasswordAlgorithmType {
    var passwordLength: Int { get set }

    func encode(rawValue: String) -> String
    func getHexPassword(raw: String) -> String
}

struct PasswordAlgorithmSHA1: PasswordAlgorithmType {
    static let identifier = "psha1"
    var passwordLength: Int = 20

    func encode(rawValue: String) -> String {
        if let stringData = rawValue.data(using: String.Encoding.utf8) {
            let input = stringData as NSData
            let digestLength = Int(CC_SHA1_DIGEST_LENGTH)
            var hash = [UInt8](repeating: 0, count: digestLength)
            CC_SHA1(input.bytes, UInt32(input.length), &hash)
            let digest = NSData(bytes: hash, length: digestLength)
            return digest.hexaAsString
        }
        return ""
    }

    func getHexPassword(raw: String) -> String {
        var password = encode(rawValue: raw)
        while password.count < 40 {
            password = "0" + password
        }
        return password
    }
}

struct PasswordAlgorithmSHA256: PasswordAlgorithmType {
    static let identifier = "psha256"
    var passwordLength: Int = 32

    func encode(rawValue: String) -> String {
        if let stringData = rawValue.data(using: String.Encoding.utf8) {
            let input = stringData as NSData
            let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
            var hash = [UInt8](repeating: 0, count: digestLength)
            CC_SHA256(input.bytes, UInt32(input.length), &hash)
            let digest = NSData(bytes: hash, length: digestLength)
            return digest.hexaAsString
        }
        return ""
    }

    func getHexPassword(raw: String) -> String {
        var password = encode(rawValue: raw)
        while password.count < 64 {
            password = "0" + password
        }
        return password
    }
}

struct PasswordAlgorithmSHA512: PasswordAlgorithmType {
    static let identifier = "psha512"
    var passwordLength: Int = 64

    func encode(rawValue: String) -> String {
        if let stringData = rawValue.data(using: String.Encoding.utf8) {
            let input = stringData as NSData
            let digestLength = Int(CC_SHA512_DIGEST_LENGTH)
            var hash = [UInt8](repeating: 0, count: digestLength)
            CC_SHA512(input.bytes, UInt32(input.length), &hash)
            let digest = NSData(bytes: hash, length: digestLength)
            return digest.hexaAsString
        }
        return ""
    }

    func getHexPassword(raw: String) -> String {
        var password = encode(rawValue: raw)
        while password.count < 128 {
            password = "0" + password
        }
        return password
    }
}
