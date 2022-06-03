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
        
        ControllerUtils.showSpinner(onView: self.view, &self.spinner)
        AuthService.shared.cdcnAuthLogin(msisdn, pin, imei) { accessToken in
            ControllerUtils.removeSpinner(self.spinner) {
                self.spinner = nil
            }
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: SegueEnum.TO_HOME_CONTROLLER.rawValue, sender: sender)
            }
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

