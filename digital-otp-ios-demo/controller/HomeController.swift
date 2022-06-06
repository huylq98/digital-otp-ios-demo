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
    var h: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: Kiểm tra lại logic huỷ đăng ký Smart OTP khi xoá app cài lại
        if defaults.string(forKey: Constant.USER_STATUS) == nil {
            SmartOTPService.shared.isRegisteredDigitalOTP() { isRegistered in
                if isRegistered {
                    SmartOTPService.shared.deregister() { isSuccess in
                        if isSuccess {
                            AppUtils.pushNotification(notificationID: "deregisterNotification", title: "Smart OTP đã bị huỷ.", content: "Smart OTP trên thiết bị này đã bị huỷ do bạn xoá app. Vui lòng đăng ký lại để sử dụng dịch vụ.", view: self)
                            DispatchQueue.main.async {
                                self.updateRegisterButton()
                            }
                        }
                    }
                }
            }
        }
        updateRegisterButton()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        SmartOTPService.shared.preRegister { data in
            let statusCode = ResponseStatusEnum(rawValue: data.status.code)
            switch statusCode {
            case .SUCCESS:
                self.confirmRegister(sender)
            case .REGISTERED_ON_ANOTHER_DEVICE:
                let actions: [UIAlertAction] = [
                    UIAlertAction(title: "Tiếp tục", style: .default) { action in
                        self.confirmRegister(sender)
                    },
                    UIAlertAction(title: "Đóng", style: .cancel)
                ]
                ControllerUtils.alert(self, title: "Xác nhận đăng ký Smart OTP", message: data.status.message, actions: actions)
            case .ALREADY_REGISTERED:
                let actions: [UIAlertAction] = [
                    UIAlertAction(title: "Xác nhận", style: .default) { action in
                        self.updateRegisterButton()
                    }
                ]
                ControllerUtils.alert(self, title: "Đã đăng ký Smart OTP", message: "Đã đăng ký Smart OTP", actions: actions)
            default:
                fatalError("Invalid status code: \(statusCode?.rawValue)")
            }
        }
    }
    
    func confirmRegister(_ sender: UIButton) {
        // Mặc định không tìm thấy là false
        if defaults.bool(forKey: Constant.USER_STATUS) {
            var actions: [UIAlertAction] = []
            actions.append(UIAlertAction(title: "Tiếp tục", style: .default, handler: { action in
                self.register(sender)
            }))
            actions.append(UIAlertAction(title: "Bỏ qua", style: .cancel))
            ControllerUtils.alert(self, title: "Tiếp tục đăng ký Smart OTP", message: "Đã có tài khoản khác đăng ký Smart OTP trên thiết bị này, bạn có chắc chắn muốn tiếp tục không?", actions: actions)
        } else {
            // Nếu user status là false thì cho phép đăng ký
            register(sender)
        }
    }
    
    func register(_ sender: UIButton) {
        ControllerUtils.showSpinner(onView: view, &spinner)
        SmartOTPService.shared.register() { h in
            ControllerUtils.removeSpinner(self.spinner) {
                self.spinner = nil
            }
            self.h = h
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: SegueEnum.HOME_CONTROLLER_TO_REGISTER_SMS_OTP_CONTROLLER.rawValue, sender: sender)
            }
        }
    }
    
    @IBAction func deregisterButtonPressed(_ sender: UIButton) {
        ControllerUtils.showSpinner(onView: view, &spinner)
        SmartOTPService.shared.deregister() { isDeregistered in
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
        performSegue(withIdentifier: SegueEnum.TO_TRASACTION_CONTROLLER.rawValue, sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueEnum.HOME_CONTROLLER_TO_REGISTER_SMS_OTP_CONTROLLER.rawValue {
            let destination = segue.destination as! RegisterSMSOTPController
            destination.h = h
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    private func updateRegisterButton() {
        ControllerUtils.showSpinner(onView: view, &spinner)
        SmartOTPService.shared.isRegisteredDigitalOTP() { isRegistered in
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
            ControllerUtils.removeSpinner(self.spinner) {
                self.spinner = nil
            }
        }
    }
}
