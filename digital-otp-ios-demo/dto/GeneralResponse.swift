//
//  GeneralResponse.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 19/05/2022.
//

import Foundation

struct GeneralResponse<T: Codable>: Codable {
    let status: Status
    let data: T?
}

struct Status: Codable {
    let code: String
    let message: String
    let responseTime: String?
    let displayMessage: String?
}
