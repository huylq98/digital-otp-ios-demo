//
//  OCRASwiftTests5.swift
//  OCRASwiftTests
//
//  Created by ttcn_cntt on 16/05/2022.
//

import digital_otp_ios_demo
import XCTest

class OCRASwiftTests5: XCTestCase {
    var testCases = [OCRASuite]()

    override func setUp() {
        super.setUp()
        testCases.append(contentsOf: [
            // suite5
            OCRASuite(ocraSuite: suite5, seed: seed64, counter: "", question: "00000000", password: "", sessionInformation: "", timeStamp: Int(Date().timeIntervalSince1970 * 1000), otpExpected: "95209754"),
            OCRASuite(ocraSuite: suite5, seed: seed64, counter: "", question: "11111111", password: "", sessionInformation: "", timeStamp: 1206446790000, otpExpected: "55907591"),
            OCRASuite(ocraSuite: suite5, seed: seed64, counter: "", question: "22222222", password: "", sessionInformation: "", timeStamp: 1206446790000, otpExpected: "22048402"),
            OCRASuite(ocraSuite: suite5, seed: seed64, counter: "", question: "33333333", password: "", sessionInformation: "", timeStamp: 1206446790000, otpExpected: "24218844"),
            OCRASuite(ocraSuite: suite5, seed: seed64, counter: "", question: "44444444", password: "", sessionInformation: "", timeStamp: 1206446790000, otpExpected: "36209546"),
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
