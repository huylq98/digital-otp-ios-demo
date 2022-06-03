//
//  LoginController.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 24/05/2022.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var msisdnTextField: UITextField!
    @IBOutlet weak var pinTextField: UITextField!
    var spinner: UIView?
    let keychain = KeychainItem()
    let defaults = UserDefaults.standard
    var loginResponse: GeneralResponse<CDCNAuth.Response>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let msisdn = msisdn(msisdnTextField.text),
              let pin = pinTextField.text else {
            fatalError("Failed to login: invalid input.")
        }
        
        var imei = "VTP_" // prefix for Android to bypass server check
        do {
            imei = imei.appending(try keychain.getDeviceImei())
        } catch {
            fatalError(error.localizedDescription)
        }
        print("IMEI = \(imei)")
        defaults.set(msisdn, forKey: Constant.MSISDN)
        defaults.set(imei, forKey: Constant.IMEI)
        defaults.set(pin, forKey: Constant.PIN)
        
        ControllerUtils.showSpinner(onView: self.view, &self.spinner)
        AuthService.shared.cdcnAuthLogin(msisdn, pin, imei) { response in
            ControllerUtils.removeSpinner(self.spinner) {
                self.spinner = nil
            }
            let responseStatus = ResponseStatusEnum(rawValue: response.status.code)
            switch responseStatus {
            case .SUCCESS:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueEnum.TO_HOME_CONTROLLER.rawValue, sender: sender)
                }
            case .NEED_VERIFY_OTP:
                self.loginResponse = response
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueEnum.LOGIN_CONTROLLER_TO_SMS_OTP_CONTROLLER.rawValue, sender: sender)
                }
            case .BLOCKED_ACCOUNT, .INVALID_SMS_OTP:
                var actions: [UIAlertAction] = []
                actions.append(UIAlertAction(title: "Xác nhận", style: .default))
                ControllerUtils.alert(self, title: response.status.message, message: response.status.displayMessage ?? "", actions: actions)
            default:
                fatalError("Invalid response code: \(responseStatus)")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueEnum.LOGIN_CONTROLLER_TO_SMS_OTP_CONTROLLER.rawValue {
            let destinationVC = segue.destination as! LoginSMSOTPController
            destinationVC.requestId = loginResponse?.data?.requestId
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    func msisdn(_ input: String?) -> String? {
        guard var msisdn = input,
              let firstNumber = msisdn.first else {
            fatalError("Failed to login: msisdn not found.")
        }
        if "0" == firstNumber {
            msisdn.removeFirst()
            return "84".appending(msisdn)
        }
        return msisdn
    }
}

