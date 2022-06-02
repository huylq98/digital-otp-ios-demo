//
//  QuestionFormatter.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation

protocol QuestionFormatType {
    var questionLength: Int { get }
    func convert2Hex(raw: String) -> String
}

extension QuestionFormatType {
    func getFixedHex(hex: String) -> String {
        var question = hex
        while question.count < 256 {
            question = question + "0"
        }
        return question
    }
}

struct QuestionNumberFormat: QuestionFormatType {
    static let identifier: String = "QN"
    var questionLength: Int = 128

    func convert2Hex(raw: String) -> String {
        return getFixedHex(hex: String(Int(raw) ?? 0, radix: 16))
    }
}

struct QuestionCharacterFormat: QuestionFormatType {
    static let identifier: String = "QA"
    var questionLength: Int = 128

    func convert2Hex(raw: String) -> String {
        return getFixedHex(hex: raw.data.hexaAsString)
    }
}

struct QuestionHexadecimalFormat: QuestionFormatType {
    static let identifier: String = "QH"
    var questionLength: Int = 128

    func convert2Hex(raw: String) -> String {
        return getFixedHex(hex: raw)
    }
}
