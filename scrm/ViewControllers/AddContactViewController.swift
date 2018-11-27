//
//  AddContactViewController.swift
//  scrm
//
//  Created by astarodub on 11/26/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {

    @IBOutlet weak var nameTextBox: UITextField!
    @IBOutlet weak var phoneTextBox: UITextField!
    @IBOutlet weak var sexSegmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func addContactClicked(_ sender: Any) {
        guard
            let name = nameTextBox.text,
            let phone = phoneTextBox.text
        else {
            self.showAlertMessage(title: "Error", msg: "Name does not exist!")
            return
        }

        let sex = sexSegmentControl.selectedSegmentIndex == 0 ? "m" : "f"
        let catId = PeopleViewController.categoryId
        
        NetUtils.addContact(name: name, phone: phone, sex: sex, category: catId) { response in
            switch response {
            case .error(let message): self.showAlertMessage(title: "Error", msg: message)
            case .success(_): self.performSegue("showContactSegue")
            }
        }
        
    }

}
