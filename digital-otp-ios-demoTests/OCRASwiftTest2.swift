//
//  OCRASwiftTest2.swift
//  OCRASwiftTests
//
//  Created by ttcn_cntt on 16/05/2022.
//

import digital_otp_ios_demo
import XCTest

class OCRASwiftTest2: XCTestCase {
    var testCases = [OCRASuite]()

    override func setUp() {
        super.setUp()
        testCases.append(contentsOf: [
            // suite2
            OCRASuite(ocraSuite: suite2, seed: seed32, counter: "0", question: "12345678", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "65347737"),
            OCRASuite(ocraSuite: suite2, seed: seed32, counter: "1", question: "12345678", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "86775851"),
            OCRASuite(ocraSuite: suite2, seed: seed32, counter: "2", question: "12345678", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "78192410"),
            OCRASuite(ocraSuite: suite2, seed: seed32, counter: "3", question: "12345678", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "71565254"),
            OCRASuite(ocraSuite: suite2, seed: seed32, counter: "4", question: "12345678", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "10104329"),
            OCRASuite(ocraSuite: suite2, seed: seed32, counter: "5", question: "12345678", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "65983500"),
            OCRASuite(ocraSuite: suite2, seed: seed32, counter: "6", question: "12345678", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "70069104"),
            OCRASuite(ocraSuite: suite2, seed: seed32, counter: "7", question: "12345678", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "91771096"),
            OCRASuite(ocraSuite: suite2, seed: seed32, counter: "8", question: "12345678", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "75011558"),
            OCRASuite(ocraSuite: suite2, seed: seed32, counter: "9", question: "12345678", password: "1234", sessionInformation: "", timeStamp: 0, otpExpected: "08522129"),

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
}
