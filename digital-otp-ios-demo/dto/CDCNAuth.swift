//
//  CDCNAuth.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 24/05/2022.
//

import Foundation

enum CDCNAuth {
    struct Request: Codable {
        init(msisdn: String, pin: String, imei: String) {
            self.msisdn = msisdn
            self.username = msisdn
            self.pin = pin
            self.notifyToken = msisdn
            self.imei = imei
        }

        var msisdn: String
        var username: String
        var pin: String
        var userType: String = "msisdn"
        var loginType: String = "BASIC"
        var notifyToken: String
        var typeOs: String = "android"
        var imei: String
        var requestId: String?
        var otp: String?
    }

    struct Response: Codable {
        var accessToken: String?
        var refreshToken: String?
        var username: String
        var userType: String
        var loginType: String
        var twofaChannelType: String?
        var twofaChannelValue: String?
        var typeOs: String
        var imei: String
        var requestId: String?
        var customerName: String?
        var verificationMethod: String?
        var otp: String?
        var notifyToken: String?
        var isLoginByToken: Bool?
        var isLoginByOldToken: Bool?
        var isByPass: Bool?
        var smartOtpInfo: SmartOTPInfo?
    }

    struct SmartOTPInfo: Codable {
        var mobileDeviceId: String?
        var registerStatus: String?
        var activeStatus: Bool?
        var userType: String?
        var phoneModel: String?
        var isAllowedSmartOtp: Bool
    }
}
