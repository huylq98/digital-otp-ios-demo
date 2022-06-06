//
//  AppConfig.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 30/05/2022.
//

import Foundation

struct AppConfig {
    private init() {}
    static let shared = AppConfig()
    
    let ocraSuite = "OCRA-1:HOTP-SHA256-6:QA06-PSHA256-T30S" // OCRA-1:HOTP-SHA256-6:QA06-PSHA256-T30S

    // Fake PIN
    let smartOTPPin = "123321"
    let transID: String = "123456"
}
