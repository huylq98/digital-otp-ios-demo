//
//  Sync.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 27/05/2022.
//

import Foundation

enum Sync {
    struct Request: Codable {
        var isRegistered: Bool

        enum CodingKeys: String, CodingKey {
            case isRegistered = "is_registered"
        }
    }

    struct Response: Codable {
        var isValidShow: Bool
        var isRegistered: Bool
        var serverTime: Int

        enum CodingKeys: String, CodingKey {
            case isValidShow = "is_valid_show"
            case isRegistered = "is_registered"
            case serverTime = "server_time"
        }
    }
}
