//
//  AddCategoryViewController.swift
//  scrm
//
//  Created by astarodub on 11/26/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {

    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var descTextBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func addCategoryClicked(_ sender: Any) {
        guard
            let name = nameTextBox.text,
            let desc = descTextBox.text
        else {
            self.showAlertMessage(title: "Error", msg: "Name not found!")
                return
        }
        
        NetUtils.addCategory(name: name, desc: desc) { response in
            switch response {
            case .error(let message): self.showAlertMessage(title: "Error", msg: message)
            case .success(_): self.performSegue("showCategoriesSegue")
            }
        }
        
    }
    
}
