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
                let alert = UIAlertController(title: "Thiết bị chưa đăng ký Smart OTP", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đăng ký Smart OTP", style: .default) { alertAction in
                    let registerController = self.storyboard?.instantiateViewController(withIdentifier: "registerController") as? RegisterController
                    guard let registerController = registerController else {
                        print("Trasaction confirmation: failed to load register view.")
                        return
                    }
                    DispatchQueue.main.async {
                        self.present(registerController, animated: true)
                    }
                })
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
}
