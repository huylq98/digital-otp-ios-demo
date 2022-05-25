//
//  ViewController.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 19/05/2022.
//

import UIKit

class RegisterController: UIViewController {
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var deregisterButton: UIButton!
    var spinner: UIView?
    
    let digitalOTPManager = DigitalOTPManager.getInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        digitalOTPManager.deregister() { isDeregistered in
            if isDeregistered {
                ControllerUtils.removeSpinner(self.spinner) {
                    self.spinner = nil
                }
                self.updateRegisterButton()
            }
        }
    }
    
    @IBAction func questionsAndAnswersButtonPressed(_ sender: UIButton) {
        print("========== Q&A ==========")
        digitalOTPManager.faq() { qa in
            print(qa!)
        }
    }
    
    @IBAction func transactionButtonPressed(_ sender: UIButton) {
        let transactionController = storyboard?.instantiateViewController(withIdentifier: "transactionView") as? TransactionController
        guard let transactionController = transactionController else {
            print("Failed to load transaction view.")
            return
        }
        present(transactionController, animated: true)
    }
    
    private func updateRegisterButton() {
        guard let msisdn = Context.msisdn else {
            print("updateRegisterButton(): msisdn not found.")
            return
        }
        guard let imei = Context.imei else {
            print("updateRegisterButton(): imei not found.")
            return
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
