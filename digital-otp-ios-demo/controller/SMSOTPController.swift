//
//  SMSOTPContoller.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 03/06/2022.
//

import UIKit

class SMSOTPController: UIViewController {

    @IBOutlet weak var smsOtpText: UITextField!
    @IBOutlet weak var countdownLabel: UILabel!
 
    var timer = Timer()
    var totalTime = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: (#selector(SMSOTPController.countdown)), userInfo: nil, repeats: true)
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
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
    }
}
