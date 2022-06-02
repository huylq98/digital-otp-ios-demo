//
//  AppUtils.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 27/05/2022.
//

import Foundation
import UserNotifications
import UIKit

struct AppUtils {
    private init () {
        fatalError("Utility class!")
    }
    
    static func currentTime() -> Int {
        let currentTime = Int(Date().timeIntervalSince1970 * 1000)
        return currentTime
    }
    
    static func encode<T: Codable>(object: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            return try encoder.encode(object)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    static func decode<T: Decodable>(json: Data, as _: T.Type) -> T? {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: json)
        } catch {
            print("An error occurred while parsing JSON")
        }
        return nil
    }
    
    static func doRequest(request: URLRequest, handler: @escaping (Data) -> Void) {
        let session = URLSession(configuration: .default)
        session.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                fatalError("Request failed: response={\(String(describing: response))}, error={\(String(describing: error))}")
            }
            handler(data)
        }.resume()
    }
    
    static func pushNotification(notificationID id: String, title: String, content: String, view: UIViewController) {
        // TODO: Push Notification
        //        if #available(iOS 10.0, *) {
        //            NotificationManager.shared.requestAuthorization()
        //            NotificationManager.shared.sendNotification(id: id, title: title, content: content)
        //        } else {
        //            let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
        //            alert.addAction(UIAlertAction(title: "Xác nhận", style: .default))
        //            view.present(alert, animated: true)
        //        }
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: content, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Xác nhận", style: .default))
            view.present(alert, animated: true)
        }
    }
}
