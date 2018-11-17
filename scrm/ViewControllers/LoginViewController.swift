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
        
        if login.isEmpty || password.isEmpty {
            self.showAlertMessage(title: "Login", msg: "Username and password cannot be empty")
        } else {
            UserUtils.loginUser(login: login, password: password) { response in
                switch (response) {
                case .error(let message):
                    self.showAlertMessage(title: "Login", msg: message)
                case .success(_):
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let (login_, _, _) = UserUtils.loadUserData()
        if let login = login_ {
            loginTextView.text = login
        }
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
