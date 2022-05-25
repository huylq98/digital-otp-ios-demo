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
    let digitalOTPManager = DigitalOTPManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let msisdn = msisdn(msisdnTextField.text) else {
            print("loginButtonPressed(): msisdn not found.")
            return
        }
        guard let pin = pinTextField.text else {
            print("loginButtonPressed(): pin not found.")
            return
        }
        guard let imei = Context.imei else {
            print("loginButtonPressed(): imei not found.")
            return
        }
        
        guard let digitalOTPController = storyboard?.instantiateViewController(withIdentifier: "registerController") as? RegisterController else {
            print("Failed to load DigitalOTPController.")
            return
        }
        ControllerUtils.showSpinner(onView: self.view, &self.spinner)
        digitalOTPManager.cdcnAuthLogin(msisdn, pin, imei) { accessToken in
            Context.accessToken = accessToken
            Context.msisdn = msisdn
            ControllerUtils.removeSpinner(self.spinner) {
                self.spinner = nil
            }
            DispatchQueue.main.async {
                self.present(digitalOTPController, animated: true)
            }
        }
        return
    }
    
    func msisdn(_ input: String?) -> String? {
        guard var msisdn = input else {
            print("msisdn(): msisdn not found.")
            return nil
        }
        guard let firstNumber = msisdn.first else {
            print("msisdn(): empty msisdn.")
            return nil
        }
        if "0" == firstNumber {
            msisdn.removeFirst()
            return "84".appending(msisdn)
        }
        return msisdn
    }
}

