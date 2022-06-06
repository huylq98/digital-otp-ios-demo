//
//  SmartOTPStatus.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 02/06/2022.
//

import Foundation

enum SmartOTPStatus {
    struct Request: Codable {}

    struct Response: Codable {
        var isRegistered: Bool?
        var deviceName: String?

        enum CodingKeys: String, CodingKey {
            case isRegistered = "is_registered"
            case deviceName = "device_name"
        }
    }
}
