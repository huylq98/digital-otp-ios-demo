//
//  TransactionController.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 25/05/2022.
//

import UIKit

class TransactionController: UIViewController {
    
    let digitalOTPManager = DigitalOTPManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        guard let msisdn = Context.msisdn else {
            print("Transaction confirmation: msisdn not found.")
            return
        }
        guard let imei = Context.imei else {
            print("Transaction confirmation: imei not found.")
            return
        }
        digitalOTPManager.isRegisteredDigitalOTP(msisdn: msisdn, imei: imei) { isRegistered in
            if !isRegistered {
                print("Transaction confirmation: device has not registered Smart OTP.")
                let alert = UIAlertController(title: "Thiết bị chưa đăng ký Smart OTP", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đăng ký Smart OTP", style: .default) { handler in
                    self.performSegue(withIdentifier: "backToRegisterController", sender: sender)
                })
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
}
