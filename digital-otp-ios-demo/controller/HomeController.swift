//
//  ViewController.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 19/05/2022.
//

import UIKit

class HomeController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var deregisterButton: UIButton!
    var spinner: UIView?
    
    let digitalOTPManager = DigitalOTPManager.shared
    let keychain = KeychainItem()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let msisdn = defaults.string(forKey: Constant.MSISDN) else {
            fatalError("Failed to read msisdn.")
        }
        guard let imei = defaults.string(forKey: Constant.IMEI) else {
            fatalError("Failed to read imei.")
        }
        if defaults.string(forKey: Constant.USER_STATUS) == nil {
            digitalOTPManager.isRegisteredDigitalOTP(msisdn: msisdn, imei: imei) { isRegistered in
                print("is registerd smart otp = \(isRegistered)")
                if isRegistered {
                    self.digitalOTPManager.deregister(imei: imei, completion: { isSuccess in
                        if isSuccess {
                            AppUtils.pushNotification(notificationID: "deregisterNoti", title: "Smart OTP đã bị huỷ.", content: "Smart OTP trên thiết bị này đã bị huỷ do bạn xoá app. Vui lòng đăng ký lại để sử dụng dịch vụ.", view: self)
                            DispatchQueue.main.async {
                                self.updateRegisterButton()
                            }
                        }
                    })
                }
            }
        }
        
        updateRegisterButton()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        ControllerUtils.showSpinner(onView: view, &spinner)
        digitalOTPManager.register() { data in
            ControllerUtils.removeSpinner(self.spinner) {
                self.spinner = nil
            }
            self.updateRegisterButton()
        }
    }
    
    @IBAction func deregisterButtonPressed(_ sender: UIButton) {
        ControllerUtils.showSpinner(onView: view, &spinner)
        guard let imei = defaults.string(forKey: Constant.IMEI) else {
            fatalError("Failed to read imei.")
        }
        digitalOTPManager.deregister(imei: imei) { isDeregistered in
            if isDeregistered {
                ControllerUtils.removeSpinner(self.spinner) {
                    self.spinner = nil
                }
                self.updateRegisterButton()
            }
        }
    }
    
    @IBAction func faqButtonPressed(_ sender: UIButton) {
        print("========== FAQ ==========")
        digitalOTPManager.faq() { faq in
            print(faq)
        }
    }
    
    @IBAction func transactionButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toTransactionController", sender: sender)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    private func updateRegisterButton() {
        guard let msisdn = defaults.string(forKey: Constant.MSISDN) else {
            fatalError("Failed to register: msisdn not found.")
        }
        guard let imei = defaults.string(forKey: Constant.IMEI) else {
            fatalError("Failed to register: imei not found.")
        }
        digitalOTPManager.isRegisteredDigitalOTP(msisdn: msisdn, imei: imei) { isRegistered in
            if isRegistered {
                print("Digital OTP Registered.")
                DispatchQueue.main.async {
                    self.registerButton.setTitle("Đã đăng ký Smart OTP", for: .normal)
                    self.registerButton.isEnabled = false
                    self.deregisterButton.isEnabled = true
                }
            } else {
                print("Digital OTP not registered.")
                DispatchQueue.main.async {
                    self.registerButton.setTitle("Đăng ký Smart OTP", for: .normal)
                    self.registerButton.isEnabled = true
                    self.deregisterButton.isEnabled = false
                }
            }
        }
    }
}
