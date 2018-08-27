//
//  NSError+Extension.swift
//  Rappi-Test
//
//  Created by Marcelo Perretta on 24/08/2018.
//  Copyright © 2018 MAWAPE. All rights reserved.
//

import UIKit

extension NSError {
    
    class func error(domain:String, code:Int, description:String ) -> Error {
        return NSError(domain: domain,
                       code: code,
                       userInfo: [ NSLocalizedDescriptionKey : description, NSDebugDescriptionErrorKey : description])
    }
    
    class func show(_ error:Error, onViewController:UIViewController)  {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.title = "Error"
        alert.message = error.localizedDescription
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        onViewController.present(alert, animated: true, completion: nil)
    }
}

