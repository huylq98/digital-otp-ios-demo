//
//  OCRASwiftTests3.swift
//  OCRASwiftTests
//
//  Created by ttcn_cntt on 16/05/2022.
//

import digital_otp_ios_demo
import XCTest

class OCRASwiftTests3: XCTestCase {
    var testCases = [OCRASuite]()

    override func setUp() {
        super.setUp()
        testCases.append(contentsOf: [
            // suite3
            OCRASuite(ocraSuite: suite3, seed: seed32, counter: "", question: "00000000", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "83238735"),
            OCRASuite(ocraSuite: suite3, seed: seed32, counter: "", question: "11111111", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "01501458"),
            OCRASuite(ocraSuite: suite3, seed: seed32, counter: "", question: "22222222", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "17957585"),
            OCRASuite(ocraSuite: suite3, seed: seed32, counter: "", question: "33333333", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "86776967"),
            OCRASuite(ocraSuite: suite3, seed: seed32, counter: "", question: "44444444", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "86807031"),
        ])
    }

    override func tearDown() {
        testCases = []
        super.tearDown()
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
}
