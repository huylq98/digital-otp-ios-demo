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
            SmartOTPService.shared.isRegisteredDigitalOTP(msisdn: msisdn, imei: imei) { isRegistered in
                print("is registerd smart otp = \(isRegistered)")
                if isRegistered {
                    SmartOTPService.shared.deregister(imei: imei, completion: { isSuccess in
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
        checkChangedDevice { isAllowedToRegister in
            if isAllowedToRegister {
                ControllerUtils.showSpinner(onView: self.view, &self.spinner)
                SmartOTPService.shared.register() { data in
                    ControllerUtils.removeSpinner(self.spinner) {
                        self.spinner = nil
                    }
                    self.updateRegisterButton()
                }
            }
        }
    }
    
    @IBAction func deregisterButtonPressed(_ sender: UIButton) {
        ControllerUtils.showSpinner(onView: view, &spinner)
        guard let imei = defaults.string(forKey: Constant.IMEI) else {
            fatalError("Failed to read imei.")
        }
        SmartOTPService.shared.deregister(imei: imei) { isDeregistered in
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
        SmartOTPService.shared.faq() { faq in
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
        SmartOTPService.shared.isRegisteredDigitalOTP(msisdn: msisdn, imei: imei) { isRegistered in
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
    
    func checkChangedDevice(completion: @escaping (Bool) -> ()) {
        guard let msisdn = defaults.string(forKey: Constant.MSISDN) else {
            fatalError("Failed to load msisdn.")
        }
        guard let imei = defaults.string(forKey: Constant.IMEI) else {
            fatalError("Failed to load imei.")
        }
        // Kiểm tra số điện thoại đã được đăng ký Smart OTP trên thiết bị này chưa
        SmartOTPService.shared.isRegisteredDigitalOTP(msisdn: msisdn, imei: imei) { isRegistered in
            if !isRegistered {
                // Kiểm tra xem số điện thoại này có được đăng ký Smart OTP trên thiết bị khác không
                SmartOTPService.shared.smartOTPStatus(msisdn: msisdn) { status in
                    guard let isRegistered = status.data?.is_registered else {
                        fatalError("Failed to check \(msisdn) Smart OTP Status.")
                    }
                    if isRegistered {
                        let alert = UIAlertController(title: "Xác nhận đăng ký Smart OTP", message: "Smart OTP đã được đăng ký trên thiết bị \(status.data?.device_name ?? "khác"). Bạn có muốn tiếp tục đăng ký trên thiết bị này không?", preferredStyle: .alert)
                        // Quyết định ghi đè
                        alert.addAction(UIAlertAction(title: "Tiếp tục", style: .default, handler: { action in
                            completion(true)
                        }))
                        alert.addAction(UIAlertAction(title: "Bỏ qua", style: .cancel, handler: { action in
                            completion(false)
                        }))
                        DispatchQueue.main.async {
                            self.present(alert, animated: true)
                        }
                    } else {
                        // Nếu chưa đăng ký trên thiết bị khác thì cho phép đăng ký
                        completion(true)
                    }
                }
            }
        }
        // Số điện thoại đăng ký Smart OTP đăng ký rồi thì thôi
        completion(false)
    }
}
