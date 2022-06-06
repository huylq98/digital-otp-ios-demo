//
//  Verify.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 27/05/2022.
//

import Foundation

enum Verify {
    struct Request: Codable {
        var otp: String
        var transId: String
        var deviceId: String
        var msisdn: String

        enum CodingKeys: String, CodingKey {
            case otp, msisdn
            case transId = "trans_id"
            case deviceId = "device_id"
        }
    }

    // Response is Bool
}
