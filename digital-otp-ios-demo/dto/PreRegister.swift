//
//  PreRegister.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 25/05/2022.
//

import Foundation

struct PreRegister {
    struct Request: Codable {
        
    }
    struct Response: Codable {
        var signedRequest: String?
    }
}
