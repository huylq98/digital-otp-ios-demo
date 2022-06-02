//
//  DigitalOTPManager.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 19/05/2022.
//

import Foundation

struct DigitalOTPManager {
    let baseURL = "http://localhost:8080"
    let userInfoService = UserInfoService()
    let keychain = KeychainItem()
    let defaults = UserDefaults.standard
    
    // Singleton
    static let shared = DigitalOTPManager()
    private init() {}
    
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
            let body = CDCNAuth.Request(msisdn: msisdn, pin: pin, imei: imei)
            request.httpBody = AppUtils.encode(object: body)
            AppUtils.doRequest(request: request) { data in
                let response = AppUtils.decode(json: data, as: GeneralResponse<CDCNAuth.Response>.self)
                guard let accessToken = response?.data?.accessToken else {
                    fatalError("cdcnAuthLogin(): Failed to get access token.")
                }
                defaults.set(accessToken, forKey: Constant.ACCESS_TOKEN)
                // sync
                isRegisteredDigitalOTP(msisdn: msisdn, imei: imei) { isRegistered in
                    if isRegistered {
                        sync (isRegistered: isRegistered) { serverTime in
                            defaults.set(serverTime - AppUtils.currentTime(), forKey: Constant.DELTA_TIME)
                        }
                    }
                }
                completion(accessToken)
            }
        }
    }
    
    func register(completion: @escaping (GeneralResponse<Register.Response>) -> ()) {
        preRegister() { h in
            guard let h = h else {
                fatalError("register(): Invalid h \(String(describing: h)).")
            }
            guard let accessToken = defaults.string(forKey: Constant.ACCESS_TOKEN) else {
                fatalError("register(): Invalid cdcn-auth access token.")
            }
            guard let imei = defaults.string(forKey: Constant.IMEI) else {
                fatalError("register(): Invalid imei.")
            }
            guard let msisdn = defaults.string(forKey: Constant.MSISDN) else {
                fatalError("register(): Invalid msisdn.")
            }
            
            // Generate key pairs, save private key in key chain
            guard let appPublicKey = userInfoService.generatePublicECKey(msisdn: msisdn) else {
                fatalError("Failed to generate key pairs.")
            }
            
            let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/register"))
            if let url = url {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                // HTTP Headers
                request.addValue(accessToken, forHTTPHeaderField: "Authorization")
                request.addValue(imei, forHTTPHeaderField: "imei")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                // HTTP Body
                let body = Register.Request(h: h, app_key: appPublicKey.hexaAsString)
                print("Register request body: \(body)")
                request.httpBody = AppUtils.encode(object: body)
                AppUtils.doRequest(request: request) { data in
                    let response = AppUtils.decode(json: data, as: GeneralResponse<Register.Response>.self)
                    guard let response = response else {
                        fatalError("register(): Invalid response \(String(describing: response)).")
                    }
                    print("Regsiter response: \(response)")
                    guard let serverPublicKey = response.data?.server_key else {
                        fatalError("Invalid server public key: \(response.data?.server_key)")
                    }
                    userInfoService.saveKeys(msisdn: msisdn, serverPublicKey: serverPublicKey, syncTime: AppUtils.currentTime())
                    defaults.set(true, forKey: Constant.USER_STATUS)
                    completion(response)
                }
            }
        }
    }
    
    func isRegisteredDigitalOTP(msisdn: String, imei: String, completion: @escaping (Bool) -> ()) {
        let url = URL(string: baseURL.appending("/digital-otp/private/v1/users/request?msisdn=\(msisdn)&deviceId=\(imei)"))
        if let url = url {
            let request = URLRequest(url: url)
            AppUtils.doRequest(request: request) { data in
                let response = AppUtils.decode(json: data, as: GeneralResponse<Bool>.self)
                completion(response?.data ?? false)
            }
        }
    }
    
    func deregister(imei: String, completion: @escaping (Bool) -> ()) {
        guard let accessToken = defaults.string(forKey: Constant.ACCESS_TOKEN) else {
            fatalError("deregister: cdcn-auth access token not found.")
        }
        let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/cancel"))
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // HTTP Headers
            request.addValue(accessToken, forHTTPHeaderField: "Authorization")
            request.addValue(imei, forHTTPHeaderField: "imei")
            
            AppUtils.doRequest(request: request) { data in
                let response = AppUtils.decode(json: data, as: GeneralResponse<Bool>.self)
                print("Deregistration response: \(String(describing: response))")
                defaults.set(false, forKey: Constant.USER_STATUS)
                completion(response?.data ?? false)
            }
        }
    }
    
    func verify(transId: String?, otp: String?, completion: @escaping (Bool) -> ()) {
        guard let imei = defaults.string(forKey: Constant.IMEI) else {
            fatalError("verify(): invalid imei.")
        }
        guard let msisdn = defaults.string(forKey: Constant.MSISDN) else {
            fatalError("verify(): invalid msisdn.")
        }
        guard let otp = otp else {
            fatalError("verify(): invalid otp.")
        }
        if let url = URL(string: baseURL.appending("/digital-otp/private/v1/users/verify")) {
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
    }
    
    func sync(isRegistered: Bool, completion: @escaping (Int) -> ()) {
        if !isRegistered {
            completion(AppUtils.currentTime())
        }
        guard let accessToken = defaults.string(forKey: Constant.ACCESS_TOKEN) else {
            fatalError("sync(): invalid accessToken.")
        }
        guard let imei = defaults.string(forKey: Constant.IMEI) else {
            fatalError("sync(): invalid imei.")
        }
        if let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/sync")) {
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
    
    func preRegister(completion: @escaping (String?) -> ()) {
        guard let accessToken = defaults.string(forKey: Constant.ACCESS_TOKEN) else {
            fatalError("preRegister(): cdcn-auth access token not found.")
        }
        guard let imei = defaults.string(forKey: Constant.IMEI) else {
            fatalError("preRegister(): Imei not found.")
        }
        if let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/register")) {
            var request = URLRequest(url: url)
            request.setValue(accessToken, forHTTPHeaderField: "Authorization")
            request.addValue(imei, forHTTPHeaderField: "imei")
            AppUtils.doRequest(request: request) { data in
                let response = AppUtils.decode(json: data, as: GeneralResponse<PreRegister.Response>.self)
                print("========== preRegister response ==========")
                print(response)
                let h = response?.data?.signedRequest?.split(separator: "=")[1]
                completion(h.map { String($0) })
            }
        }
    }
}
