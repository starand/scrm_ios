//
//  ViewController.swift
//  scrm
//
//  Created by astarodub on 10/23/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var categories: [Category] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let (login_, pswd_, _) = UserUtils.loadUserData()
        
        if let login = login_, let pswd = pswd_ {
            UserUtils.loginUser(login: login, password: pswd) { response in
                switch response {
                case .error(_):
                    self.performSegue(withIdentifier: "showLoginViewSegue", sender: self)
                case .success(_):
                    self.loadNotes()
                }
            }
        } else {
            self.performSegue(withIdentifier: "showLoginViewSegue", sender: self)
        }
    }
    
    func loadCategories() {
        NetUtils.fetchCategories() { response in
            switch response {
            case .error(let message):
                print(message)
            case .success(let json):
                self.categories = JsonUtils.parseCategories(json)
                self.displayCategories()
            }
        }
    }
    
    func displayCategories() {
        
    }
}

