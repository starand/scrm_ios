//
//  UIUtils.swift
//  scrm
//
//  Created by astarodub on 10/27/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func showAlertMessage(title: String, msg: String) {
        //
        //
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
