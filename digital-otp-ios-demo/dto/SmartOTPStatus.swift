//
//  SmartOTPStatus.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 02/06/2022.
//

import Foundation

struct SmartOTPStatus {
    struct Request: Codable {
        
    }
    
    struct Response: Codable {
        var is_registered: Bool?
        var device_name: String?
    }
}
