//
//  Register.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 24/05/2022.
//

import Foundation
import UIKit

struct VerifyRegistration {
    struct Request: Codable {
        init(h: String, app_key: String, otp: String) {
            self.h = h
            self.app_key = app_key
            self.otp = otp
        }
        var otp: String
        var h: String
        var app_key: String
        var device_name = UIDevice.current.name
    }
    
    struct Response: Codable {
        var server_key: String
        var server_time: Int
    }
}
