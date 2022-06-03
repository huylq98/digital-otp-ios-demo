//
//  OTPPopUpController.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 26/05/2022.
//

import UIKit

class OTPPopUpController: UIViewController {
    
    @IBOutlet weak var transactionInfoLabel: UILabel!
    @IBOutlet weak var generatedOTPLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    
    let userInfoService = UserInfoService()
    var timer = Timer()
    var totalTime = 60
    var generatedOTP: String?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let msisdn = defaults.string(forKey: Constant.MSISDN) else {
            fatalError("popupController: msisdn not found.")
        }
        transactionInfoLabel.text = "Xác nhận chuyển 1.000đ cho số điện thoại \(msisdn), phí GD 0đ."
        generatedOTP = userInfoService.generateOTP(msisdn: msisdn, question: AppConfig.shared.transID, pinOtp: AppConfig.shared.smartOTPPin)
        print("Generated OTP: \(generatedOTP)")
        generatedOTPLabel.text = generatedOTP
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(OTPPopUpController.countdown)), userInfo: nil, repeats: true)
    }
    
    @objc func countdown() {
        if totalTime > 0 {
            totalTime -= 1
            countdownLabel.text = "\(totalTime) giây"
        } else {
            timer.invalidate()
            dismiss(animated: true)
        }
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        SmartOTPService.shared.verify(transId: AppConfig.shared.transID, otp: generatedOTP) { isVerified in
            if(isVerified) {
                DispatchQueue.main.sync {
                    let alert = UIAlertController(title: "Thành công!", message: "Bạn đã thực hiện chuyển tiền thành công.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Xác nhận", style: .default) { handler in
                        self.dismiss(animated: true)
                        self.performSegue(withIdentifier: SegueEnum.BACK_TO_TRANSACTION_CONTROLLER.rawValue, sender: sender)
                    })
                    self.present(alert, animated: true)
                }
            } else {
                DispatchQueue.main.sync {
                    let alert = UIAlertController(title: "Thất bại!", message: "Đã có lỗi xảy ra. Vui lòng thực hiện lại.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Xác nhận", style: .default) { handler in
                        self.dismiss(animated: true)
                        self.performSegue(withIdentifier: SegueEnum.BACK_TO_TRANSACTION_CONTROLLER.rawValue, sender: sender)
                    })
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
}
