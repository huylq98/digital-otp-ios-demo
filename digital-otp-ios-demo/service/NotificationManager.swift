//
//  LocalNotificationManager.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 02/06/2022.
//

import Foundation
import UserNotifications

@available(iOS 10.0, *)
class NotificationManager {
    private init() {
    }
    static let shared = NotificationManager()
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization() {
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .badge, .sound)
        self.userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
    
    func sendNotification(id notificationID: String, title: String, content: String) {
        // Create new notifcation content instance
        let notificationContent = UNMutableNotificationContent()
        
        // Add the content to the notification content
        notificationContent.title = title
        notificationContent.body = content
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: notificationID,
                                            content: notificationContent,
                                            trigger: trigger)
        
        userNotificationCenter.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
