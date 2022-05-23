//
//  CDCNAuthResponse.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 20/05/2022.
//

import Foundation

struct CDCNAuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let username: String
    let userType: String
    let loginType: String
    let twofaChannelType: String
    let twofaChannelValue: String
    let typeOs: String
    let imei: String
    let customerName: String
    let verificationMethod: String
}
