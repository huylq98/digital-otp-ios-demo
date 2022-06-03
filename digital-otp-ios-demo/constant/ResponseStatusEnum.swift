//
//  ResponseStatusEnum.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 03/06/2022.
//

import Foundation

enum ResponseStatusEnum: String {
    case SUCCESS = "00"
    case NEED_VERIFY_OTP = "AUT0014"
    case WRONG_SMS_OTP = "AUT0108"
    case BLOCKED_ACCOUNT = "AUT0026"
    case INVALID_SMS_OTP = "AUT0009"
    case REGISTERED_ON_ANOTHER_DEVICE = "DIGITAL-OTP-0007"
    case ALREADY_REGISTERED = "DIGITAL-OTP-0010"
}
