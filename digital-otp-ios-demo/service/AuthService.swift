//
//  AuthService.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 02/06/2022.
//

import Foundation

class AuthService {
    private init(){}
    static let shared = AuthService()
    
    let defaults = UserDefaults.standard
    
    func cdcnAuthLogin(_ msisdn: String, _ pin: String, _ imei: String, _ requestId: String? = nil, _ otp: String? = nil, completion: @escaping (GeneralResponse<CDCNAuth.Response>) -> ()) {
        if let url = URL(string: "http://125.235.38.229:8080".appending("/auth/v1/authn/login")) {
            var request = URLRequest(url: url)
            
            // HTTP Method
            request.httpMethod = "POST"
            
            // HTTP Headers
            request.addValue("vi", forHTTPHeaderField: "Accept-Language")
            request.addValue("APP", forHTTPHeaderField: "Authority-Party")
            request.addValue("VIETTELPAY", forHTTPHeaderField: "Product")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // HTTP Body
            var body = CDCNAuth.Request(msisdn: msisdn, pin: pin, imei: imei)
            if let requestId = requestId,
               let otp = otp {
                body.requestId = requestId
                body.otp = otp
            }
            request.httpBody = AppUtils.encode(object: body)
            AppUtils.doRequest(request: request) { data in
                let response = AppUtils.decode(json: data, as: GeneralResponse<CDCNAuth.Response>.self)
                print("========== LOGIN RESPONSE ==========")
                guard let response = response else {
                    fatalError("Invalid response: \(response)")
                }
                print(response)
                let responseStatus = ResponseStatusEnum(rawValue: response.status.code)
                switch responseStatus {
                case .SUCCESS:
                    guard let accessToken = response.data?.accessToken else {
                        fatalError("Failed to get access token.")
                    }
                    self.defaults.set(accessToken, forKey: Constant.ACCESS_TOKEN)
                    // sync
                    SmartOTPService.shared.isRegisteredDigitalOTP() { isRegistered in
                        if isRegistered {
                            SmartOTPService.shared.sync (isRegistered: isRegistered) { serverTime in
                                self.defaults.set(serverTime - AppUtils.currentTime(), forKey: Constant.DELTA_TIME)
                            }
                        }
                    }
                    print("Access token = \(accessToken)")
                    completion(response)
                case .NEED_VERIFY_OTP:
                    completion(response)
                case .WRONG_SMS_OTP:
                    completion(response)
                case .BLOCKED_ACCOUNT:
                    completion(response)
                case .INVALID_SMS_OTP:
                    completion(response)
                default:
                    fatalError("Failed to login.")
                }
            }
        }
    }
}
