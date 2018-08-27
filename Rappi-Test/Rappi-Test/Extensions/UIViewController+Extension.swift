//
//  UIViewController+Extension.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

import Foundation
import UIKit

public  extension UIViewController {
    
    /**
     Creates an intance of `UIViewController` based in a storyboard file name
     - returns: An instance of `UIViewController`
     */
    class func create() -> UIViewController {
        if let name = NSStringFromClass(self).components(separatedBy: ".").last {
            return UIStoryboard(name: name, bundle: nil).instantiateInitialViewController()!
        }
        return UIViewController()
    }
    
    func alert(message: String, title: String = "") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "ACCEPT", style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Loading View
    func createSpinner() -> UIView {
        let spinnerView = UIView.init(frame: view.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        spinnerView.alpha = 0.0
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {return}
            
            spinnerView.addSubview(ai)
            
            if let navigation = `self`.navigationController {
                navigation.view.addSubview(spinnerView)
            } else {
                `self`.view.addSubview(spinnerView)
            }
        }
        return spinnerView
    }
    
    func showOrHideSpinner(spinner: UIView, mustHideSpinner: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, animations: {
                spinner.alpha = mustHideSpinner ? 0.0 : 1.0
            })
        }
    }
}

