//
//  OCRASwiftTests.swift
//  OCRASwiftTests
//
//  Created by ttcn_cntt on 16/05/2022.
//

import digital_otp_ios_demo
import XCTest

class OCRATests: XCTestCase {
    var testCases = [OCRASuite]()

    override func setUp() {
        super.setUp()
        testCases.append(contentsOf: [
            // suite1
            OCRASuite(ocraSuite: suite1, seed: seed20, counter: "", question: "00000000", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "237653"),
            OCRASuite(ocraSuite: suite1, seed: seed20, counter: "", question: "11111111", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "243178"),
            OCRASuite(ocraSuite: suite1, seed: seed20, counter: "", question: "22222222", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "653583"),
            OCRASuite(ocraSuite: suite1, seed: seed20, counter: "", question: "33333333", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "740991"),
            OCRASuite(ocraSuite: suite1, seed: seed20, counter: "", question: "44444444", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "608993"),
            OCRASuite(ocraSuite: suite1, seed: seed20, counter: "", question: "55555555", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "388898"),
            OCRASuite(ocraSuite: suite1, seed: seed20, counter: "", question: "66666666", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "816933"),
            OCRASuite(ocraSuite: suite1, seed: seed20, counter: "", question: "77777777", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "224598"),
            OCRASuite(ocraSuite: suite1, seed: seed20, counter: "", question: "88888888", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "750600"),
            OCRASuite(ocraSuite: suite1, seed: seed20, counter: "", question: "99999999", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "294470"),

            // OCRASuite(ocraSuite: "", seed: "", counter: "", question: "", password: "", sessionInformation: "", timeStamp: 0, otpExpected: ""),

        ])
    }

    override func tearDown() {
        testCases = []
        super.tearDown()
    }
    
    func testOCRA100() {
        let ocra = OCRASuite(ocraSuite: "OCRA-1:HOTP-SHA256-6:QA06-PSHA256-T30S", seed: "794e547edc31528627a7b94ef27d4283e9c9c41e5aafaaf86d9334b4be0f4aa0", counter: "", question: "123456", password: "123321", sessionInformation: "", timeStamp: 0, otpExpected: "721293")
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }

    func testOCRA1() {
        let ocra = testCases[0]
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }

    func testOCRA2() {
        let ocra = testCases[1]
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }

    func testOCRA3() {
        let ocra = testCases[2]
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }

    func testOCRA4() {
        let ocra = testCases[3]
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }

    func testOCRA5() {
        let ocra = testCases[4]
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }

    func testOCRA6() {
        let ocra = testCases[5]
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }

    func testOCRA7() {
        let ocra = testCases[6]
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }

    func testOCRA8() {
        let ocra = testCases[7]
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }

    func testOCRA9() {
        let ocra = testCases[8]
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }

    func testOCRA10() {
        let ocra = testCases[9]
        let generator: OCRABuilderInterface = OCRAGenerator()
            .accept(suite: ocra.ocraSuite, key: ocra.seed)
            .params(counter: ocra.counter, question: ocra.question, password: ocra.password)
            .sessionWith(sessionInfo: ocra.sessionInformation, timestamp: ocra.timeStamp)

        let otpCode = generator.generateOTP()
        XCTAssertEqual(otpCode, ocra.otpExpected)
    }
    
    func test(){
        let currentTime = Int(Date().timeIntervalSince1970 * 1000)
        print(currentTime)
        
    }
}
