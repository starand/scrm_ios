//
//  LoginViewController.swift
//  scrm
//
//  Created by astarodub on 10/27/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    
    @IBAction func loginTapped(_ sender: Any) {
        let login = loginTextView.text!
        let password = passwordTextView.text!
        
        if (login == "1" && password == "1") {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
