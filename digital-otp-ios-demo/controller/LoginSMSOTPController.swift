//
//  SMSOTPContoller.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 03/06/2022.
//

import UIKit

class LoginSMSOTPController: UIViewController {
    @IBOutlet var smsOtpText: UITextField!
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var informationText: UILabel!
    
    var timer = Timer()
    var totalTime = 60
    let defaults = UserDefaults.standard
    var requestId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        informationText.text = "Vui lòng nhập mã OTP được gửi về SĐT \(defaults.string(forKey: Constant.MSISDN ?? "")) để đăng nhập"
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(LoginSMSOTPController.countdown), userInfo: nil, repeats: true)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        // handling code
        view.endEditing(true)
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
        guard let otp = smsOtpText.text,
              let requestId = requestId,
              let msisdn = defaults.string(forKey: Constant.MSISDN),
              let pin = defaults.string(forKey: Constant.PIN),
              let imei = defaults.string(forKey: Constant.IMEI)
        else {
            fatalError("Invalid input.")
        }
        AuthService.shared.cdcnAuthLogin(msisdn, pin, imei, requestId, otp) { response in
            let responseStatus = ResponseStatusEnum(rawValue: response.status.code)
            switch responseStatus {
            case .SUCCESS:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueEnum.SMS_OTP_CONTROLLER_TO_HOME_CONTROLLER.rawValue, sender: sender)
                }
            case .WRONG_SMS_OTP, .INVALID_SMS_OTP, .BLOCKED_ACCOUNT:
                var actions: [UIAlertAction] = []
                actions.append(UIAlertAction(title: "Xác nhận", style: .default))
                ControllerUtils.alert(self, title: response.status.message, message: response.status.displayMessage ?? "", actions: actions)
            default:
                fatalError("Invalid response status: \(responseStatus)")
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: SegueEnum.SMS_OTP_CONTROLLER_BACK_TO_LOGIN_CONTROLLER.rawValue, sender: sender)
    }
    
    // Prevent automatically segue
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
}
