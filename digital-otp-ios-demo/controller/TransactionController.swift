//
//  TransactionController.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 25/05/2022.
//

import UIKit

class TransactionController: UIViewController {
    
    @IBOutlet weak var receivedPhoneNumber: UITextField!
    @IBOutlet weak var amount: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        guard let msisdn = defaults.string(forKey: Constant.MSISDN) else {
            fatalError("Transaction confirmation: msisdn not found.")
        }
        guard let imei = defaults.string(forKey: Constant.IMEI) else {
            fatalError("Transaction confirmation: imei not found.")
        }
        checkRegisterDiginalOTP(msisdn: msisdn, imei: imei, sender)
        guard let receivedPhoneNumber = receivedPhoneNumber.text else {
            fatalError("Transaction confirmation: receivedPhoneNumber not found.")
        }
        guard let amount = amount.text else {
            fatalError("Transaction confirmation: amount not found.")
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueEnum.BACK_TO_HOME_CONTROLLER.rawValue, sender: sender)
    }
    
    private func checkRegisterDiginalOTP(msisdn: String, imei: String, _ sender: UIButton) {
        SmartOTPService.shared.isRegisteredDigitalOTP() { isRegistered in
            if !isRegistered {
                print("Transaction confirmation: device has not registered Smart OTP.")
                let alert = UIAlertController(title: "Thiết bị chưa đăng ký Smart OTP", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đăng ký Smart OTP", style: .default) { handler in
                    self.performSegue(withIdentifier: SegueEnum.BACK_TO_HOME_CONTROLLER.rawValue, sender: sender)
                })
                alert.addAction(UIAlertAction(title: "Đóng", style: .cancel))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: SegueEnum.TO_POP_UP_CONTROLLER.rawValue, sender: sender)
                }
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
}
