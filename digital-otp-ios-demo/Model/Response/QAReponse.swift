//
//  QAndAReponse.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 19/05/2022.
//

import Foundation

struct QAResponse: Codable {
    let id: Int
    let question: String
    let answer: String
    let isExpand: Bool
}
