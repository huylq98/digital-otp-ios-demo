//
//  SegueEnum.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 03/06/2022.
//

import Foundation

enum SegueEnum: String {
    case TO_HOME_CONTROLLER = "toHomeController"
    case BACK_TO_HOME_CONTROLLER = "backToHomeController"
    case TO_TRASACTION_CONTROLLER = "toTransactionController"
    case BACK_TO_TRANSACTION_CONTROLLER = "backToTransactionController"
    case TO_POP_UP_CONTROLLER = "toPopUpController"
    case LOGIN_CONTROLLER_TO_SMS_OTP_CONTROLLER = "LoginControllerToSMSOTPController"
    case SMS_OTP_CONTROLLER_TO_HOME_CONTROLLER = "SMSOTPControllerToHomeController"
    case SMS_OTP_CONTROLLER_BACK_TO_LOGIN_CONTROLLER = "SMSOTPControllerBackToLoginController"
    case HOME_CONTROLLER_TO_REGISTER_SMS_OTP_CONTROLLER = "HomeControllerToRegisterSMSOTPController"
    case REGISTER_SMS_OTP_CONTROLLER_TO_HOME_CONTROLLER = "RegisterSMSOTPControllerToHomeController"
}
