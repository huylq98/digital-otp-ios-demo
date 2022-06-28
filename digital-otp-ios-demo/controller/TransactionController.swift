//
//  TransactionController.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 25/05/2022.
//

import UIKit

class TransactionController: UIViewController {
    @IBOutlet var receivedPhoneNumber: UITextField!
    @IBOutlet var amount: UITextField!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        // handling code
        view.endEditing(true)
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        guard let msisdn = defaults.string(forKey: Constant.MSISDN) else {
            fatalError("Transaction confirmation: msisdn not found.")
        }
        guard let imei = defaults.string(forKey: Constant.IMEI) else {
            fatalError("Transaction confirmation: imei not found.")
        }
        checkRegisterDiginalOTP(msisdn: msisdn, imei: imei, sender)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueEnum.BACK_TO_HOME_CONTROLLER.rawValue, sender: sender)
    }
    
    private func checkRegisterDiginalOTP(msisdn: String, imei: String, _ sender: UIButton) {
        SmartOTPService.shared.isRegisteredDigitalOTP { isRegistered in
            if !isRegistered {
                print("Transaction confirmation: device has not registered Smart OTP.")
                let alert = UIAlertController(title: "Thiết bị chưa đăng ký Smart OTP", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Đăng ký Smart OTP", style: .default) { _ in
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let msisdn = defaults.string(forKey: Constant.MSISDN) else {
            fatalError("popupController: msisdn not found.")
        }
        
        guard let receivedPhoneNumber = receivedPhoneNumber.text else {
            fatalError("Transaction confirmation: receivedPhoneNumber not found.")
        }
        guard let amount = amount.text else {
            fatalError("Transaction confirmation: amount not found.")
        }
        let transID = UUID().uuidString
        if segue.identifier == SegueEnum.TO_POP_UP_CONTROLLER.rawValue {
            let destinationVC = segue.destination as! OTPPopUpController
            destinationVC.generatedOTP = UserInfoService.shared.generateOTP(msisdn: msisdn, question: transID, pinOtp: AppConfig.shared.smartOTPPin)
            destinationVC.receivedPhoneNumber = receivedPhoneNumber
            destinationVC.amount = amount
            destinationVC.transID = transID
            print("Generated OTP: \(destinationVC.generatedOTP)")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
}
