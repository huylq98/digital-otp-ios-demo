////
////  ECCKeyPairTest.swift
////  OCRASwiftTests
////
////  Created by ttcn_cntt on 25/05/2022.
////
//
//import digital_otp_ios_demo
//import XCTest
//
//class ECCKeyPairTest: XCTestCase {
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
////         let domain = Domain.instance(curve: .EC256r1)
////         let (publicKey, privateKey): (ECPublicKey, ECPrivateKey) = domain.makeKeyPair()
////        print(publicKey.der.hexaAsString)
////        print(privateKey.derPkcs8.hexaAsString)
//        let appPrivate = "308193020100301306072a8648ce3d020106082a8648ce3d030107047930770201010420a315d7e5a839056ac0996282463c7a877dcd6dbf2f3eb280fc223bb135b9b2eba00a06082a8648ce3d030107a144034200047f4f75a8aaa096f062baab7a6993bf485d0d061698090b2aa668e8944cca7394007b53b0e93c51efb6d55a1606ad20aeb2905b8c90669c66a74c5ed663d34486"
//        let appPublic = "3059301306072a8648ce3d020106082a8648ce3d030107034200047f4f75a8aaa096f062baab7a6993bf485d0d061698090b2aa668e8944cca7394007b53b0e93c51efb6d55a1606ad20aeb2905b8c90669c66a74c5ed663d34486"
//        //3059301306072a8648ce3d020106082a8648ce3d030107034200047f4f75a8aaa096f062baab7a6993bf485d0d061698090b2aa668e8944cca7394007b53b0e93c51efb6d55a1606ad20aeb2905b8c90669c66a74c5ed663d34486
//        let serverPublic = "3059301306072a8648ce3d020106082a8648ce3d0301070342000494d093940f3469c5381dfede2aabac9fbf42edbd90ad9575880bd3b22ac6202beca90ff4ce05b12f25ecacbd4b7c66a2c5583cf30ea34e1e1bd62dbb536eb8d1"
//                          //3059301306072a8648ce3d020106082a8648ce3d0301070342000494d093940f3469c5381dfede2aabac9fbf42edbd90ad9575880bd3b22ac6202beca90ff4ce05b12f25ecacbd4b7c66a2c5583cf30ea34e1e1bd62dbb536eb8d1
//        let serverPrivate = "3041020100301306072a8648ce3d020106082a8648ce3d0301070427302502010104209ced93e85ba711c5fd9b240374866506327b3b6d5f5cff68de2c92e556e5c9bf"
//                           //3041020100301306072a8648ce3d020106082a8648ce3d0301070427302502010104209ced93e85ba711c5fd9b240374866506327b3b6d5f5cff68de2c92e556e5c9bf
////        3041020100301306072a8648ce3d020106082a8648ce3d03010704273025020101042021a102a7f36957f4904f2fa12a341a0ef9d18927e498aa5025914f49f157d128
////        3041020100301306072a8648ce3d020106082a8648ce3d0301070427302502010104209ced93e85ba711c5fd9b240374866506327b3b6d5f5cff68de2c92e556e5c9bf
////        3041020100301306072a8648ce3d020106082a8648ce3d0301070427302502010104209ced93e85ba711c5fd9b240374866506327b3b6d5f5cff68de2c92e556e5c9bf
////        let javaPrivate = "3041020100301306072a8648ce3d020106082a8648ce3d03010704273025020101042068a60d88864d1be06a0e3d6740460a1a95c2c38f5420c9d4791597cf8671bd4c"
//
//        let javaPublicKey = try ECPublicKey(der: serverPublic.hexaBytes)
//        let javaPrivateKey = try ECPrivateKey(der: serverPrivate.hexaBytes, pkcs8: true)
//        let appPrivateKey = try ECPrivateKey(der: appPrivate.hexaBytes, pkcs8: true)
//        let iosPublicKey = try ECPublicKey(der: appPublic.hexaBytes)
//
//        print("=======")
//        let info: Bytes = []
//        let secretA = try appPrivateKey.keyAgreement(pubKey: javaPublicKey, length: 32, md: .SHA2_256, sharedInfo: info)
//        let secretB = try javaPrivateKey.keyAgreement(pubKey: iosPublicKey, length: 32, md: .SHA2_256, sharedInfo: info)
//        print(secretA.hexaAsString)
//        print(secretB.hexaAsString)
//        //64e886197f2a280f76ebd30ac8951a6cee0b6f89a356cc7810be85ed8da7e9be
//        //23029bf7f177306d594092b5c485cf4b675772c2ad1bd246bd9b025fb783d5d2
//        //aa88358ef2fe0dd5ed87c24b5475f6aeabcf9eaa3059ca5b556be016a4e14810
//        //aa88358ef2fe0dd5ed87c24b5475f6aeabcf9eaa3059ca5b556be016a4e14810
//        //aa88358ef2fe0dd5ed87c24b5475f6aeabcf9eaa3059ca5b556be016a4e14810
//        //da3beb73baaf825381b7268aa57b60995fc72e50cc96785e55c42a086747bee3
//        //da3beb73baaf825381b7268aa57b60995fc72e50cc96785e55c42a086747bee3
//        //aa88358ef2fe0dd5ed87c24b5475f6aeabcf9eaa3059ca5b556be016a4e14810
//        //f7c2c201caba5404dc40731a33cb0d8f305aa95e002587c85ada184c5dc764a3
//    }
//
////    func testKeychain() {
////        let user = UserInfo(userId: "+84962403494")
////        do {
////            // TODO: Replace
////            let keychain = try KeychainItem(service: "serviceID", account: user.storedIdentifier())
////            try keychain.saveData(of: user)
////            let userData = try keychain.readData(of: user)
////            print(userData.storedIdentifier())
////
////        } catch {
////            print(error)
////        }
////    }
//}
