//
//  DigitalOTPManager.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 19/05/2022.
//

import Foundation

struct SmartOTPService {
    let baseURL = "http://125.235.38.229:8080"
    let userInfoService = UserInfoService()
    let keychain = KeychainItem()
    let defaults = UserDefaults.standard
    
    // Singleton
    static let shared = SmartOTPService()
    private init() {}
    
    func preRegister(completion: @escaping (GeneralResponse<Bool>) -> ()) {
        if let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/request")) {
            var request = URLRequest(url: url)
            guard let accessToken = defaults.string(forKey: Constant.ACCESS_TOKEN),
                  let imei = defaults.string(forKey: Constant.IMEI) else {
                fatalError("Failed to pre-register.")
            }
            request.addValue(accessToken, forHTTPHeaderField: "Authorization")
            request.addValue(imei, forHTTPHeaderField: "imei")
            
            AppUtils.doRequest(request: request) { data in
                let response = AppUtils.decode(json: data, as: GeneralResponse<Bool>.self)
                guard let response = response else {
                    fatalError("preRegister: Invalid response.")
                }
                print("========== PreRegistration Response ==========")
                print(response)
                completion(response)
            }
        }
    }
    
    func register(completion: @escaping (String?) -> ()) {
        guard let accessToken = defaults.string(forKey: Constant.ACCESS_TOKEN),
              let imei = defaults.string(forKey: Constant.IMEI),
              let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/register")) else {
            fatalError("Failed to register.")
        }
        var request = URLRequest(url: url)
        request.setValue(accessToken, forHTTPHeaderField: "Authorization")
        request.addValue(imei, forHTTPHeaderField: "imei")
        AppUtils.doRequest(request: request) { data in
            let response = AppUtils.decode(json: data, as: GeneralResponse<Registration.Response>.self)
            print("========== preRegister response ==========")
            print(response)
            let h = response?.data?.signedRequest?.split(separator: "=")[1]
            completion(h.map { String($0) })
        }
    }
    
    func verifyRegister(completion: @escaping (GeneralResponse<VerifyRegistration.Response>) -> ()) {
        register() { h in
            guard let h = h,
                  let accessToken = defaults.string(forKey: Constant.ACCESS_TOKEN),
                  let imei = defaults.string(forKey: Constant.IMEI),
                  let msisdn = defaults.string(forKey: Constant.MSISDN),
                  let appPublicKey = userInfoService.generatePublicECKey(msisdn: msisdn),
                  let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/register")) else {
                fatalError("Failed to register.")
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // HTTP Headers
            request.addValue(accessToken, forHTTPHeaderField: "Authorization")
            request.addValue(imei, forHTTPHeaderField: "imei")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // HTTP Body
            let body = VerifyRegistration.Request(h: h, app_key: appPublicKey.hexaAsString)
            print("Register request body: \(body)")
            request.httpBody = AppUtils.encode(object: body)
            AppUtils.doRequest(request: request) { data in
                let response = AppUtils.decode(json: data, as: GeneralResponse<VerifyRegistration.Response>.self)
                guard let response = response,
                      let serverPublicKey = response.data?.server_key else {
                    fatalError("register(): Invalid response \(String(describing: response)).")
                }
                print("Regsiter response: \(response)")
                userInfoService.saveKeys(msisdn: msisdn, serverPublicKey: serverPublicKey, syncTime: AppUtils.currentTime())
                defaults.set(true, forKey: Constant.USER_STATUS)
                completion(response)
            }
        }
    }
    
    func isRegisteredDigitalOTP(completion: @escaping (Bool) -> ()) {
        guard let msisdn = defaults.string(forKey: Constant.MSISDN),
              let imei = defaults.string(forKey: Constant.IMEI),
              let url = URL(string: baseURL.appending("/digital-otp/private/v1/users/request?msisdn=\(msisdn)&deviceId=\(imei)")) else {
            fatalError("isRegisteredDigitalOTP: Invalid input.")
        }
        let request = URLRequest(url: url)
        AppUtils.doRequest(request: request) { data in
            let response = AppUtils.decode(json: data, as: GeneralResponse<Bool>.self)
            guard let isRegistered = response?.data else {
                fatalError("Invalid response: \(response)")
            }
            completion(isRegistered)
        }
    }
    
    func deregister(completion: @escaping (Bool) -> ()) {
        guard let accessToken = defaults.string(forKey: Constant.ACCESS_TOKEN),
              let imei = defaults.string(forKey: Constant.IMEI),
              let msisdn = defaults.string(forKey: Constant.MSISDN),
              let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/cancel")) else {
            fatalError("Failed to deregister.")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // HTTP Headers
        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        request.addValue(imei, forHTTPHeaderField: "imei")
        
        AppUtils.doRequest(request: request) { data in
            let response = AppUtils.decode(json: data, as: GeneralResponse<Bool>.self)
            guard let isSuccess = response?.data else {
                fatalError("Invalid response: \(response)")
            }
            defaults.set(false, forKey: Constant.USER_STATUS)
            do {
                try keychain.deleteData(by: msisdn)
            } catch {
                print(error.localizedDescription)
            }
            completion(isSuccess)
        }
    }
    
    func verify(transId: String?, otp: String?, completion: @escaping (Bool) -> ()) {
        guard let imei = defaults.string(forKey: Constant.IMEI),
              let msisdn = defaults.string(forKey: Constant.MSISDN),
              let otp = otp,
              let url = URL(string: baseURL.appending("/digital-otp/private/v1/users/verify")) else {
            fatalError("Failed to verify.")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // HTTP Body
        let body = Verify.Request(otp: otp, trans_id: transId ?? "", device_id: imei, msisdn: msisdn)
        request.httpBody = AppUtils.encode(object: body)
        
        AppUtils.doRequest(request: request) { data in
            let response = AppUtils.decode(json: data, as: GeneralResponse<Bool>.self)
            print("========== Transaction verification response ==========")
            print(response)
            completion(response?.data ?? false)
        }
    }
    
    func sync(isRegistered: Bool, completion: @escaping (Int) -> ()) {
        if !isRegistered {
            completion(AppUtils.currentTime())
        }
        guard let accessToken = defaults.string(forKey: Constant.ACCESS_TOKEN),
              let imei = defaults.string(forKey: Constant.IMEI),
              let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/sync")) else {
            fatalError("Failed to sync.")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // HTTP Headers
        request.addValue(accessToken, forHTTPHeaderField: "Authorization")
        request.addValue(imei, forHTTPHeaderField: "imei")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // HTTP Body
        let body = Sync.Request(is_registered: isRegistered)
        request.httpBody = AppUtils.encode(object: body)
        AppUtils.doRequest(request: request) { data in
            let response = AppUtils.decode(json: data, as: GeneralResponse<Sync.Response>.self)
            guard let serverTime = response?.data?.server_time else {
                fatalError("Failed to get server time.")
            }
            completion(serverTime)
        }
    }
    
    func faq(completion: @escaping (GeneralResponse<[FAQ.Response]>?) -> ()) {
        if let url = URL(string: baseURL.appending("/digital-otp/public/v1/common/qa")) {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Constant.BEARER_TOKEN)", forHTTPHeaderField: "Authorization")
            AppUtils.doRequest(request: request) { data in
                let response = AppUtils.decode(json: data, as: GeneralResponse<[FAQ.Response]>.self)
                completion(response)
            }
        }
    }
    
    func smartOTPStatus(msisdn: String, completion: @escaping (GeneralResponse<SmartOTPStatus.Response>) -> ()) {
        if let url = URL(string: baseURL.appending("/digital-otp/public/v1/cms/status?msisdn=\(msisdn)")) {
            var request = URLRequest(url: url)
            request.addValue(Constant.BEARER_TOKEN, forHTTPHeaderField: "Authorization")
            AppUtils.doRequest(request: request) { data in
                let response = AppUtils.decode(json: data, as: GeneralResponse<SmartOTPStatus.Response>.self)
                guard let response = response else {
                    fatalError("Failed to check Smart OTP Status for \(msisdn)")
                }
                completion(response)
            }
        }
        
    }
}
