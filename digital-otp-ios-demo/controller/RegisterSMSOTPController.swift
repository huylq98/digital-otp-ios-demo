//
//  RegisterSMSOTPController.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 03/06/2022.
//

import UIKit

class RegisterSMSOTPController: UIViewController {
    
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var smsOtpText: UITextField!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var h: String?
    let defaults = UserDefaults.standard
    var timer = Timer()
    var totalTime = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        informationLabel.text =  "Vui lòng nhập mã OTP được gửi về SĐT \(defaults.string(forKey: Constant.MSISDN) ?? "") để xác nhận đăng ký Smart OTP"
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(RegisterSMSOTPController.countdown)), userInfo: nil, repeats: true)
    }
    
    @objc func countdown() {
        if totalTime > 0 {
            totalTime -= 1
            countdownLabel.text = "\(totalTime)"
        } else {
            timer.invalidate()
            dismiss(animated: true)
        }
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        guard let h = h,
              let otp = smsOtpText.text else {
            fatalError("Invalid input")
        }
        SmartOTPService.shared.verifyRegister(h: h, otp: otp) { response in
            let responseStatus = ResponseStatusEnum(rawValue: response.status.code)
            switch responseStatus {
            case .SUCCESS:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueEnum.REGISTER_SMS_OTP_CONTROLLER_TO_HOME_CONTROLLER.rawValue, sender: sender)
                }
            case .WRONG_SMS_OTP, .BLOCKED_ACCOUNT, .INVALID_SMS_OTP:
                var actions: [UIAlertAction] = []
                actions.append(UIAlertAction(title: "Xác nhận", style: .default) { action in
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: SegueEnum.REGISTER_SMS_OTP_CONTROLLER_TO_HOME_CONTROLLER.rawValue, sender: sender)
                    }
                })
                ControllerUtils.alert(self, title: response.status.message, message: response.status.displayMessage ?? "", actions: actions)
            default:
                fatalError("Invalid response status: \(responseStatus)")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: SegueEnum.REGISTER_SMS_OTP_CONTROLLER_TO_HOME_CONTROLLER.rawValue, sender: sender)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
}
