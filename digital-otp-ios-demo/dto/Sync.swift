//
//  Sync.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 27/05/2022.
//

import Foundation

struct Sync {
    struct Request: Codable {
        var is_registered: Bool
    }
    
    struct Response: Codable {
        var is_valid_show: Bool
        var is_registered: Bool
        var server_time: Int
    }
}
