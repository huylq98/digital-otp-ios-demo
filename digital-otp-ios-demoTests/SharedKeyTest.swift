//
//  KeyPairtTest.swift
//  digital-otp-ios-demoTests
//
//  Created by Lê Quốc Huy on 06/06/2022.
//

import digital_otp_ios_demo
import XCTest

struct KeyPair {
    var msisdn: String
    var privateKey: String
    var publicKey: String
    var expectedSharedKey: String
}

let userId = "8467476393"

class SharedKeyTest: XCTestCase {
    var testCases = [KeyPair]()

    override func setUp() {
        testCases.append(contentsOf: [
            KeyPair(msisdn: userId, privateKey: "308187020100301306072a8648ce3d020106082a8648ce3d030107046d306b02010104201b8779b85eba016dc5ac62e6ff3733a528f647368c03b3155a5edfaa1baf6f97a14403420004c9f6ec7e69bae1ff4902e4cf30bc4fb68e6bd8c309c1fbe48e617fd89a23dbac4eb70162a696a7b5fbcd80afd9e384dc8682870f6d8273403230320e27194357", publicKey: "3059301306072a8648ce3d020106082a8648ce3d0301070342000461db50795d213b610ef0778adffd14b742e1550877be52266a563b39f9bd9519ce62da10c08f88a95758edf05d6a6ad481c68952a3862b8d3ea4c4345ad99443", expectedSharedKey: "a08c0f395b74bd5893d19f4633316d3681f591a243786c9c9b1cd29b87f75119"),
            KeyPair(msisdn: userId, privateKey: "3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420e8e92128dcdbc9fc4311b4ee93e2ecdc0eedcb9fef4fc8e813af5bc27c8fd077", publicKey: "3059301306072a8648ce3d020106082a8648ce3d03010703420004c9f6ec7e69bae1ff4902e4cf30bc4fb68e6bd8c309c1fbe48e617fd89a23dbac4eb70162a696a7b5fbcd80afd9e384dc8682870f6d8273403230320e27194357", expectedSharedKey: "a08c0f395b74bd5893d19f4633316d3681f591a243786c9c9b1cd29b87f75119"),
            KeyPair(msisdn: userId, privateKey: "308187020100301306072a8648ce3d020106082a8648ce3d030107046d306b02010104204de53400e4fc772dd6845a51839caa89086714ea13f68064d159c01c0902c2f6a144034200043a8abbfc21abb9ee5bbbfda376626367b437a27e17d7e14042a8771e16e4fe1a50c2f603ef5e71176eca254e4abfbf70e9aae3591653f214912fe67ba07be878", publicKey: "3059301306072a8648ce3d020106082a8648ce3d03010703420004934ab42f15146f792801f45e250a44a72d6a46a7ac31b485fe6c5106e26ab6ce18c4a9cdeeba63d7b55e4e1e5e7d009961121f8c5724ac5abbbba4654c579675", expectedSharedKey: "474b31ff0086b88853ab0d9c0e76c7732b9171e0ba9288c91ecc498a8f15ff5c"),
            KeyPair(msisdn: userId, privateKey: "3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420affdd81517f885e7b9c0cbe4da8a582b62affa87a4f0d57625956d74813e95c5", publicKey: "3059301306072a8648ce3d020106082a8648ce3d030107034200043a8abbfc21abb9ee5bbbfda376626367b437a27e17d7e14042a8771e16e4fe1a50c2f603ef5e71176eca254e4abfbf70e9aae3591653f214912fe67ba07be878", expectedSharedKey: "474b31ff0086b88853ab0d9c0e76c7732b9171e0ba9288c91ecc498a8f15ff5c"),
            KeyPair(msisdn: userId, privateKey: "308187020100301306072a8648ce3d020106082a8648ce3d030107046d306b020101042086896bb36086cb1fcdf2fac44be33783ed4aad1d36f43fdc9cdf2eb44be9497fa144034200041c0ba471523cf81b520a4ed1cd572bf8286186176d90481f3699fce36b6408a97ac61eeede0ecb68d4047f8c95c97153ce39ba85ecdc3cf40d8d2edb1d733c7e", publicKey: "3059301306072a8648ce3d020106082a8648ce3d0301070342000443c01bc561b982a5e6fe6a3803ffa5ca90fe9e12c5c71e6b562e0255bef1f2ea904ed683ca0564828b58106f56b7f942c3470842aa8d09a715c662d00dc2c856", expectedSharedKey: "9e210a9e01f6a3a8367ea27b8b3d8224d58126577da9cb60c110abf42427f7e5"),
            KeyPair(msisdn: userId, privateKey: "3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420f6cb1666904572d5a5315b2f9942c2d4018e654a33311a857ef8d4fa22f3f397", publicKey: "3059301306072a8648ce3d020106082a8648ce3d030107034200041c0ba471523cf81b520a4ed1cd572bf8286186176d90481f3699fce36b6408a97ac61eeede0ecb68d4047f8c95c97153ce39ba85ecdc3cf40d8d2edb1d733c7e", expectedSharedKey: "9e210a9e01f6a3a8367ea27b8b3d8224d58126577da9cb60c110abf42427f7e5"),
            KeyPair(msisdn: userId, privateKey: "308187020100301306072a8648ce3d020106082a8648ce3d030107046d306b02010104202d49978175a05db78b4666272165f185c853bf3bba9eef52cbc0111ab11eb592a14403420004db01e627c8c781dfb56dd1c480b18d7c73c053feeeab9581549487e5124e009868e2ed87449808ef6d3d299c599a64401220d0c5c2a50ce00f122c1753e119bd", publicKey: "3059301306072a8648ce3d020106082a8648ce3d030107034200043d13579827761601edc63ab10b6d10eca35a8ea26d78a109360d15e42f47256b2c97009d2ac8c7de6fe9eb625dc8e1ed675a622685a3fc9fc2e7a35775233649", expectedSharedKey: "5d728844babcb02f44ebffaa19097d67c5ff52df8878df736c62981f2538bb75"),
            KeyPair(msisdn: userId, privateKey: "3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420f8c0d701f68e8f948d0dc98bb98bf8a04c3b581bcef4e966c4a01b98c856c87c", publicKey: "3059301306072a8648ce3d020106082a8648ce3d03010703420004db01e627c8c781dfb56dd1c480b18d7c73c053feeeab9581549487e5124e009868e2ed87449808ef6d3d299c599a64401220d0c5c2a50ce00f122c1753e119bd", expectedSharedKey: "5d728844babcb02f44ebffaa19097d67c5ff52df8878df736c62981f2538bb75"),
            KeyPair(msisdn: userId, privateKey: "308187020100301306072a8648ce3d020106082a8648ce3d030107046d306b02010104204f93d71e8ad58328d0fde026f14d61c100167c7fc3b900ff0df4d58f711b87dfa144034200040e764ab7930fdd1ed55505d3aa86b7ddf70f06aa89cbc5012a8234f82e93c4160a959531d101cd6055ea97c27515e8d08d44c348ea4079f07f7fce61ce1dc20f", publicKey: "3059301306072a8648ce3d020106082a8648ce3d03010703420004b19b76beb14a5a2c8d0fc7d0df2697b5e9ffd8f888e7d88fd666af14301218fa471bfee09c78a2c8549e0bcae15cd98ab9740a49acf98610d87b48c3937d7242", expectedSharedKey: "ade852668d7a21dcdb786335c2fab30c7241ad47ab02044b8cb61b74899e2a5a"),
            KeyPair(msisdn: userId, privateKey: "3041020100301306072a8648ce3d020106082a8648ce3d030107042730250201010420bfadeee67a395dddc3d515491c18407c87e1633eb4aae9e72a7ea1ef506d7f5d", publicKey: "3059301306072a8648ce3d020106082a8648ce3d030107034200040e764ab7930fdd1ed55505d3aa86b7ddf70f06aa89cbc5012a8234f82e93c4160a959531d101cd6055ea97c27515e8d08d44c348ea4079f07f7fce61ce1dc20f", expectedSharedKey: "ade852668d7a21dcdb786335c2fab30c7241ad47ab02044b8cb61b74899e2a5a")

        ])
    }
    
    override func tearDown() {
        testCases = []
        super.tearDown()
    }

    func getSharedKey(user: UserInfo) -> String? {
        var sharedKey: String?
        if #available(iOS 14.0, *) {
            sharedKey = UserInfoService.shared.getSharedNative(by: user)
        } else {
            sharedKey = UserInfoService.shared.getShared(by: user)
        }
        return sharedKey
    }

    func testKeyPair1() throws {
        let keyPair = testCases[0]
        let user = UserInfo(userId: keyPair.msisdn, privateKey: keyPair.privateKey, serverPublicKey: keyPair.publicKey)
        XCTAssertEqual(getSharedKey(user: user), keyPair.expectedSharedKey)
    }

    func testKeyPair2() throws {
        let keyPair = testCases[1]
        let user = UserInfo(userId: keyPair.msisdn, privateKey: keyPair.privateKey, serverPublicKey: keyPair.publicKey)
        XCTAssertEqual(getSharedKey(user: user), keyPair.expectedSharedKey)
    }

    func testKeyPair3() throws {
        let keyPair = testCases[2]
        let user = UserInfo(userId: keyPair.msisdn, privateKey: keyPair.privateKey, serverPublicKey: keyPair.publicKey)
        XCTAssertEqual(getSharedKey(user: user), keyPair.expectedSharedKey)
    }
    
    func testKeyPair4() throws {
        let keyPair = testCases[3]
        let user = UserInfo(userId: keyPair.msisdn, privateKey: keyPair.privateKey, serverPublicKey: keyPair.publicKey)
        XCTAssertEqual(getSharedKey(user: user), keyPair.expectedSharedKey)
    }
    
    func testKeyPair5() throws {
        let keyPair = testCases[4]
        let user = UserInfo(userId: keyPair.msisdn, privateKey: keyPair.privateKey, serverPublicKey: keyPair.publicKey)
        XCTAssertEqual(getSharedKey(user: user), keyPair.expectedSharedKey)
    }
    
    func testKeyPair6() throws {
        let keyPair = testCases[5]
        let user = UserInfo(userId: keyPair.msisdn, privateKey: keyPair.privateKey, serverPublicKey: keyPair.publicKey)
        XCTAssertEqual(getSharedKey(user: user), keyPair.expectedSharedKey)
    }
    
    func testKeyPair7() throws {
        let keyPair = testCases[6]
        let user = UserInfo(userId: keyPair.msisdn, privateKey: keyPair.privateKey, serverPublicKey: keyPair.publicKey)
        XCTAssertEqual(getSharedKey(user: user), keyPair.expectedSharedKey)
    }
    
    func testKeyPair8() throws {
        let keyPair = testCases[7]
        let user = UserInfo(userId: keyPair.msisdn, privateKey: keyPair.privateKey, serverPublicKey: keyPair.publicKey)
        XCTAssertEqual(getSharedKey(user: user), keyPair.expectedSharedKey)
    }
    
    func testKeyPair9() throws {
        let keyPair = testCases[8]
        let user = UserInfo(userId: keyPair.msisdn, privateKey: keyPair.privateKey, serverPublicKey: keyPair.publicKey)
        XCTAssertEqual(getSharedKey(user: user), keyPair.expectedSharedKey)
    }
    
    func testKeyPair10() throws {
        let keyPair = testCases[9]
        let user = UserInfo(userId: keyPair.msisdn, privateKey: keyPair.privateKey, serverPublicKey: keyPair.publicKey)
        XCTAssertEqual(getSharedKey(user: user), keyPair.expectedSharedKey)
    }
}
