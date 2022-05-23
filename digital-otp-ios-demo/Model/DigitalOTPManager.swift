//
//  DigitalOTPManager.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 19/05/2022.
//

import Foundation

struct DigitalOTPManager {
    fileprivate let baseURL = "http://125.235.38.229:8080"
    fileprivate let bearerToken = "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIwMUU0UThONzIzUDJQS0FXS1NON1Q4OUowNCIsImF1ZCI6IlRISVJEX1BBUlRZIiwidXNyIjoiV0VCQVBQIiwicm9sZXMiOlsiV0VCX0FETUlOIiwiVEhJUkRfUEFSVFkiLCJBRE1JTiIsIkNTX1JFQURfREVUQUlMIiwiUFVTSF9OT1RJRlkiXSwidHlwZSI6IjNSRF9UT0tFTiIsImlhdCI6MTYxNDU4OTM1MCwiZXhwIjoyMjQ1NzI4MzkwLCJqdGkiOiIwMUVaUEdDTVNNQkFTR0RWV0FXNTEwTTBENSJ9.oHOOQVPEBcHFzG4QiGRC4HPePcmrn6Z7f3hq0b8H6BNPADFr6JC8BRbszL8U/GRXjnWW/b39o69C+OSDWBFg9W4bsScZHpXbsVHh8b/gov9SQy+KIoHG+yDh/XOt2orHqqI51u8pBUq5eLmndqUP38e9H6VGwwbhnVuFH/5UqtedV9CrqwYYaQtQM5U4xaiAuZIs9AV0T9OWEWaIm8FZvoH81bHkikCj2LPvFdlH/alBqjojUJVQi6OL5ICodDrctT8Y1wJLLmcM5uZSjh1F9lDfzhQ36sqA6tRRf8mhfa5+VuC1F9r9A6WSmQvnNNl6vdSlxBTVJB21llqhEovh1WD2MKsSUS1MQHBPiZMNG3xRq7PrYSxsefgxurUM+M15kCbMvEn2ny/ubYCENdAEV2n0ofEZDYVePqlbkTcq3SXf73ROfIMCv9lhA4yPNgqQ1WE7KeJ0cKKIMuFkNe+aceN8KBYwoK+pXQe3RECAKDNoQIQ8owq1d/TJOHemqa/iIxkYEcUM56LC688pjPYb6zFAq6HVBe+1sS++OQ98aZyGlsZyJP1rZ4RcxwPl5zAqooozrtzIM8129i8+BdGpeO0k2pzGpjEGMWupE2JPzgYAhG3DbvObNGB6RPdk+7e88p5sk9dET9SvpBRCuNaavdcb5lALksOWzrgKBAG1TFs="
    fileprivate let imei = "VTP_DFCB65E1A8F83065BB52A8E7DD8FCE5C"
    
    func register(completion: @escaping (Data) -> ()) {
        cdcnAuthLogin() { accessToken in
            guard let accessToken = accessToken else {
                print("Invalid cdcn-auth access token.")
                return
            }
            preRegister(accessToken: accessToken) { h in
                guard let h = h else {
                    print("Invalid h.")
                    return
                }
                print("h: \(h)")
                let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/register"))
                if let url = url {
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    
                    // HTTP Headers
                    request.addValue(accessToken, forHTTPHeaderField: "Authorization")
                    request.addValue(imei, forHTTPHeaderField: "imei")
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    // HTTP Body
                    let parameters = [
                        "otp": "1111",
                        "h": h,
                        "app_key": "54555a72643056335755684c6231704a656d6f775130465257556c4c6231704a656d6f7752454652593052525a30464661465a4d626a4d794d6e42464b7a467663555a4a64564e594e4656475a464a58536e564d555642525246567a4e6a6c484e6a4e61566e4a6c656b68325a6c70515255315864577061647a4d7664455934575452755a3346734f4646475a57643661475a5853306c5261565a744b306f304b3045395051",
                        "device_name": "Redmi"
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
                    doRequest(request: request) { data in
                        completion(data)
                    }
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
    
    func qa(completion: @escaping (GeneralResponse<[QAResponse]>?) -> ()) {
        if let url = URL(string: baseURL.appending("/digital-otp/public/v1/common/qa")) {
            var request = URLRequest(url: url)
            request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
            doRequest(request: request) { data in
                completion(parseJSON(data: data, as: GeneralResponse<[QAResponse]>.self))
            }
        }
    }
}

fileprivate struct GetRegisterResponse: Codable {
    let signedRequest: String
}


extension DigitalOTPManager {
    fileprivate func cdcnAuthLogin(completion: @escaping (String?) -> ()) {
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
            let parameters = [
                "msisdn": "84967476393",
                "username": "84967476393",
                "pin": "123123",
                "userType": "msisdn",
                "loginType": "BASIC",
                "notifyToken": "84967476393",
                "typeOs": "android",
                "imei": imei
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            doRequest(request: request) { data in
                let response = parseJSON(data: data, as: GeneralResponse<CDCNAuthResponse>.self)
                completion(response?.data.accessToken)
            }
        }
    }
    
    
    fileprivate func preRegister(accessToken: String, completion: @escaping (String?) -> ()) {
        if let url = URL(string: baseURL.appending("/digital-otp/public/v1/users/register")) {
            var request = URLRequest(url: url)
            request.setValue(accessToken, forHTTPHeaderField: "Authorization")
            request.addValue(imei, forHTTPHeaderField: "imei")
            doRequest(request: request) { data in
                let response = parseJSON(data: data, as: GeneralResponse<GetRegisterResponse>.self)
                let h = response?.data.signedRequest.split(separator: "=")[1]
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
