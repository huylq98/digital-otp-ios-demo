//
//  Register.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 24/05/2022.
//

import Foundation
import UIKit

enum VerifyRegistration {
    struct Request: Codable {
        init(h: String, appKey: String, otp: String) {
            self.h = h
            self.appKey = appKey
            self.otp = otp
        }

        var otp: String
        var h: String
        var appKey: String
        var deviceName = UIDevice.current.name

        enum CodingKeys: String, CodingKey {
            case otp, h
            case appKey = "app_key"
            case deviceName = "device_name"
        }
    }

    struct Response: Codable {
        var serverKey: String
        var serverTime: Int

        enum CodingKeys: String, CodingKey {
            case serverKey = "server_key"
            case serverTime = "server_time"
        }
    }
}
