//
//  ViewUtils.swift
//  digital-otp-ios-demo
//
//  Created by Lê Quốc Huy on 24/05/2022.
//

import Foundation
import UIKit

struct ControllerUtils {
    static func showSpinner(onView view: UIView, _ spinner: inout UIView?) {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            view.addSubview(spinnerView)
        }
        
        spinner = spinnerView
    }
    
    static func removeSpinner(_ spinner: UIView?, _ completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            spinner?.removeFromSuperview()
            completion()
        }
    }
}
