//
//  OCRASwiftTests4.swift
//  OCRASwiftTests
//
//  Created by ttcn_cntt on 16/05/2022.
//

import digital_otp_ios_demo
import XCTest

class OCRASwiftTests4: XCTestCase {

    var testCases = [OCRASuite]()

    override func setUp() {
        super.setUp()
        testCases.append(contentsOf: [
            // suite4
            OCRASuite(ocraSuite: suite4, seed: seed64, counter: "00000", question: "00000000", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "07016083"),
            OCRASuite(ocraSuite: suite4, seed: seed64, counter: "00001", question: "11111111", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "63947962"),
            OCRASuite(ocraSuite: suite4, seed: seed64, counter: "00002", question: "22222222", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "70123924"),
            OCRASuite(ocraSuite: suite4, seed: seed64, counter: "00003", question: "33333333", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "25341727"),
            OCRASuite(ocraSuite: suite4, seed: seed64, counter: "00004", question: "44444444", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "33203315"),
            OCRASuite(ocraSuite: suite4, seed: seed64, counter: "00005", question: "55555555", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "34205738"),
            OCRASuite(ocraSuite: suite4, seed: seed64, counter: "00006", question: "66666666", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "44343969"),
            OCRASuite(ocraSuite: suite4, seed: seed64, counter: "00007", question: "77777777", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "51946085"),
            OCRASuite(ocraSuite: suite4, seed: seed64, counter: "00008", question: "88888888", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "20403879"),
            OCRASuite(ocraSuite: suite4, seed: seed64, counter: "00009", question: "99999999", password: "", sessionInformation: "", timeStamp: 0, otpExpected: "31409299"),

            // OCRASuite(ocraSuite: "", seed: "", counter: "", question: "", password: "", sessionInformation: "", timeStamp: 0, otpExpected: ""),

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
