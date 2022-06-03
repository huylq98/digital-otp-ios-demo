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
        init(h: String, app_key: String) {
            self.h = h
            self.app_key = app_key
        }
        var otp: String = "1111"
        var h: String
        var app_key: String
        var device_name = UIDevice.current.name
    }
    
    struct Response: Codable {
        var server_key: String
        var server_time: Int
    }
}