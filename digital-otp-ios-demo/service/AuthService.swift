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
    
    func cdcnAuthLogin(_ msisdn: String, _ pin: String, _ imei: String, completion: @escaping (String?) -> ()) {
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
            request.httpBody = AppUtils.encode(object: body)
            AppUtils.doRequest(request: request) { data in
                var response = AppUtils.decode(json: data, as: GeneralResponse<CDCNAuth.Response>.self)
                print("========== LOGIN RESPONSE ==========")
                print(response)
                // Cần xác thực SMS OTP
                if response?.status.code == Constant.NEED_VERIFY_OTP {
                    print("Need verify OTP")
                    body.requestId = response?.data?.requestId
                    body.otp = "1111" // TODO: Hardcode for STAGING
                    request.httpBody = AppUtils.encode(object: body)
                    AppUtils.doRequest(request: request) { data in
                        response = AppUtils.decode(json: data, as: GeneralResponse<CDCNAuth.Response>.self)
                        guard let accessToken = response?.data?.accessToken else {
                            fatalError("cdcnAuthLogin(): Failed to get access token.")
                        }
                        self.defaults.set(accessToken, forKey: Constant.ACCESS_TOKEN)
                        // sync
                        SmartOTPService.shared.isRegisteredDigitalOTP(msisdn: msisdn, imei: imei) { isRegistered in
                            if isRegistered {
                                SmartOTPService.shared.sync (isRegistered: isRegistered) { serverTime in
                                    self.defaults.set(serverTime - AppUtils.currentTime(), forKey: Constant.DELTA_TIME)
                                }
                            }
                        }
                        completion(accessToken)
                    }
                } else if response?.status.code == "00" {
                    guard let accessToken = response?.data?.accessToken else {
                        fatalError("cdcnAuthLogin(): Failed to get access token.")
                    }
                    self.defaults.set(accessToken, forKey: Constant.ACCESS_TOKEN)
                    // sync
                    SmartOTPService.shared.isRegisteredDigitalOTP(msisdn: msisdn, imei: imei) { isRegistered in
                        if isRegistered {
                            SmartOTPService.shared.sync (isRegistered: isRegistered) { serverTime in
                                self.defaults.set(serverTime - AppUtils.currentTime(), forKey: Constant.DELTA_TIME)
                            }
                        }
                    }
                    completion(accessToken)
                } else {
                    fatalError("Failed to login.")
                }
            }
        }
    }
}
