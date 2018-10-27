//
//  ViewController.swift
//  scrm
//
//  Created by astarodub on 10/23/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!UserUtils.isUserLoggedIn()) {
            self.performSegue(withIdentifier: "showLoginViewSegue", sender: self)
        }
    }


}

