//
//  ECCKeyCryptor.swift
//  OCRASwiftTests
//
//  Created by ttcn_cntt on 31/05/2022.
//

import CryptoKit
import XCTest

class ECCKeyCryptor: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
//        let iosPrivate = "308193020100301306072a8648ce3d020106082a8648ce3d030107047930770201010420c162a45d869f8016eea4e73f52c204303e8d391651a581dd7e04aa4f7a37635aa00a06082a8648ce3d030107a14403420004e11220c6293e34b45be1b1a33a28babb11bb86a954dae541702c453392acfc71f5772e734cff7560d800ca2cd70cbe9cfae043094cc179b75923c5c1f3087d29"
        let iosPrivate = "308193020100301306072a8648ce3d020106082a8648ce3d030107047930770201010420a315d7e5a839056ac0996282463c7a877dcd6dbf2f3eb280fc223bb135b9b2eba00a06082a8648ce3d030107a144034200047f4f75a8aaa096f062baab7a6993bf485d0d061698090b2aa668e8944cca7394007b53b0e93c51efb6d55a1606ad20aeb2905b8c90669c66a74c5ed663d34486"
        let iosPublic = "3059301306072a8648ce3d020106082a8648ce3d03010703420004e11220c6293e34b45be1b1a33a28babb11bb86a954dae541702c453392acfc71f5772e734cff7560d800ca2cd70cbe9cfae043094cc179b75923c5c1f3087d29"
//        let javaPublic = "3059301306072a8648ce3d020106082a8648ce3d03010703420004b59ab50fa9c653077d087a5a8d18dff83e79ea3c97c238a85c2350f2bf11a1c7cbfcd94462bb9b7e7f02389c9c7eb8b9fe67ecfcdd7dd7b074315f493406f000"
        let javaPrivate = "3041020100301306072a8648ce3d020106082a8648ce3d03010704273025020101042068a60d88864d1be06a0e3d6740460a1a95c2c38f5420c9d4791597cf8671bd4c"
        let javaPublic = "3059301306072a8648ce3d020106082a8648ce3d0301070342000494d093940f3469c5381dfede2aabac9fbf42edbd90ad9575880bd3b22ac6202beca90ff4ce05b12f25ecacbd4b7c66a2c5583cf30ea34e1e1bd62dbb536eb8d1"
        let privateKey = try P256.KeyAgreement.PrivateKey.init(derRepresentation: iosPrivate.hexaBytes)
        let publicKey = try P256.KeyAgreement.PublicKey.init(derRepresentation: javaPublic.hexaBytes)
        let sharedKey = try privateKey.sharedSecretFromKeyAgreement(with: publicKey)
        let sharedKeyAsHexaString = sharedKey.withUnsafeBytes { pointer in
            pointer.hexaAsString
        }
        print(sharedKeyAsHexaString)
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0 ..< length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
}
