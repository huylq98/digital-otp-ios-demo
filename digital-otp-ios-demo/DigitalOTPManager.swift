//
//  DigitalOTPManager.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 19/05/2022.
//

import Foundation

struct DigitalOTPManager {
    fileprivate let baseURL = "http://125.235.38.229:8080"
    fileprivate let encoder = JSONEncoder()
    fileprivate let decoder = JSONDecoder()
    
    private init() {}
    
    private struct InstanceHolder {
        static let INSTANCE = DigitalOTPManager()
    }
    
    static func getInstance() -> DigitalOTPManager {
        return InstanceHolder.INSTANCE
    }
    
    func cdcnAuthLogin(_ msisdn: String, _ pin: String, _ imei: String, completion: @escaping (String?) -> ()) {
        if let url = URL(string: baseURL.appending("/auth/v1/authn/login")) {
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
            request.httpBody = try? encoder.encode(body)
            doRequest(request: request) { data in
                let response = parseJSON(data: data, as: GeneralResponse<CDCNAuth.Response>.self)
                completion(response?.data.accessToken)
            }
        }
    }
    
    func register(completion: @escaping (GeneralResponse<Register.Response>) -> ()) {
        preRegister() { h in
            guard let h = h else {
                print("register(): Invalid h.")
                return
            }
            guard let accessToken = Context.accessToken else {
                print("register(): Invalid cdcn-auth access token.")
                return
            }
            guard let imei = Context.imei else {
                print("register(): Invalid imei.")
                return
            }
            print("Request register Digital OTP success! h: \(h)")
            let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/register"))
            if let url = url {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                
                // HTTP Headers
                request.addValue(accessToken, forHTTPHeaderField: "Authorization")
                request.addValue(imei, forHTTPHeaderField: "imei")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
                // HTTP Body
                let body = Register.Request(h: h)
                print("register() - request body: \(body)")
                request.httpBody = try? encoder.encode(body)
                doRequest(request: request) { data in
                    let response = parseJSON(data: data, as: GeneralResponse<Register.Response>.self)
                    guard let response = response else {
                        print("register(): Invalid response.")
                        return
                    }
                    print("Regsiter response: \(response)")
                    completion(response)
                }
            }
        }
    }
    
    func isRegisteredDigitalOTP(msisdn: String, imei: String, completion: @escaping (Bool) -> ()) {
        let url = URL(string: baseURL.appending("/digital-otp/private/v1/users/request?msisdn=\(msisdn)&deviceId=\(imei)"))
        if let url = url {
            let request = URLRequest(url: url)
            doRequest(request: request) { data in
                let response = parseJSON(data: data, as: GeneralResponse<Bool>.self)
                completion(response?.data ?? false)
            }
        }
    }
    
    func deregister(completion: @escaping (Bool) -> ()) {
        guard let accessToken = Context.accessToken else {
            print("deregister: cdcn-auth access token not found.")
            return
        }
        guard let imei = Context.imei else {
            print("deregister: imei not found.")
            return
        }
        let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/cancel"))
        if let url = url {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // HTTP Headers
            request.addValue(accessToken, forHTTPHeaderField: "Authorization")
            request.addValue(imei, forHTTPHeaderField: "imei")
            
            doRequest(request: request) { data in
                let response = parseJSON(data: data, as: GeneralResponse<Bool>.self)
                print("Deregistration response: \(response)")
                completion(response?.data ?? false)
            }
        }
    }
    
    func faq(completion: @escaping (GeneralResponse<[FAQ.Response]>?) -> ()) {
        if let url = URL(string: baseURL.appending("/digital-otp/public/v1/common/qa")) {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(Context.bearerToken)", forHTTPHeaderField: "Authorization")
            doRequest(request: request) { data in
                completion(parseJSON(data: data, as: GeneralResponse<[FAQ.Response]>.self))
            }
        }
    }
}

extension DigitalOTPManager {
    
    fileprivate func preRegister(completion: @escaping (String?) -> ()) {
        guard let accessToken = Context.accessToken else {
            print("preRegister(): cdcn-auth access token not found.")
            return
        }
        print("preRegister(): accessToken={\(accessToken)}")
        guard let imei = Context.imei else {
            print("preRegister(): Imei not found.")
            return
        }
        print("preRegister(): imei={\(imei)}")
        if let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/register")) {
            var request = URLRequest(url: url)
            request.setValue(accessToken, forHTTPHeaderField: "Authorization")
            request.addValue(imei, forHTTPHeaderField: "imei")
            doRequest(request: request) { data in
                let response = parseJSON(data: data, as: GeneralResponse<PreRegister.Response>.self)
                print("preRegister(): response={\(response)}")
                let h = response?.data.signedRequest?.split(separator: "=")[1]
                completion(h.map { String($0) })
            }
        }
    }
    
    
    fileprivate func doRequest(request: URLRequest, handler: @escaping (Data) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Response: \(response)")
                print("Error: \(error)")
                return
            }
            handler(data)
        }.resume()
    }
    
    fileprivate func parseJSON<T: Decodable>(data: Data, as clazz: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(clazz, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
