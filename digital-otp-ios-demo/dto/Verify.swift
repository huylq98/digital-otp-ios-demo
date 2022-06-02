//
//  Verify.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 27/05/2022.
//

import Foundation

struct Verify {
    struct Request: Codable {
        var otp: String
        var trans_id: String
        var device_id: String
        var msisdn: String
    }
    
    // Response is Bool
}
