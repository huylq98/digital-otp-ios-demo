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
    
    var timer = Timer()
    var totalTime = 60
    var receivedPhoneNumber: String?
    var amount: String?
    var transID: String?
    var generatedOTP: String?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transactionInfoLabel.text = "Xác nhận chuyển \(amount!)đ cho số điện thoại \(receivedPhoneNumber!), phí GD 0đ."
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
        guard let transID = transID else {
            fatalError("Invalid transID.")
        }
        SmartOTPService.shared.verify(transId: transID, otp: generatedOTP) { isVerified in
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
