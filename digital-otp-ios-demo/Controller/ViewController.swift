//
//  ViewController.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 19/05/2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var registerDigitalOTPButton: UIButton!
    let digitalOTPManager = DigitalOTPManager()
    let msisdn = "84967476393"
    let imei = "VTP_DFCB65E1A8F83065BB52A8E7DD8FCE5C"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        updateRegisterButton()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        digitalOTPManager.register() { data in
            self.updateRegisterButton()
        }
    }
    
    @IBAction func questionsAndAnswersButtonPressed(_ sender: UIButton) {
        print("========== Q&A ==========")
        digitalOTPManager.qa() { qa in
            print(qa!)
        }
    }
    
    private func updateRegisterButton() {
        digitalOTPManager.isRegisteredDigitalOTP(msisdn: msisdn, imei: imei) { isRegistered in
            if isRegistered {
                DispatchQueue.main.async {
                    self.registerDigitalOTPButton.setTitle("Đã đăng ký Smart OTP", for: .normal)
                    self.registerDigitalOTPButton.isEnabled = false
                }
            }
        }
    }
}

