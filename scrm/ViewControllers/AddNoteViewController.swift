//
//  AddNoteViewController.swift
//  scrm
//
//  Created by astarodub on 11/26/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addNoteClick(_ sender: Any) {
        guard let title = titleTextField.text, let desc = descTextView.text else {
            self.showAlertMessage(title: "Error", msg: "Title not found")
            return
        }
        
        if title.count == 0 {
            self.showAlertMessage(title: "Error", msg: "Title should not be empty")
            return
        }
        
        NetUtils.addNote(PersonViewController.personId, title: title, desc: desc) { response in
            switch response {
            case .error(let message): self.showAlertMessage(title: "Error", msg: message)
            case .success(_): self.performSegue("showHistorySegue")
            }
        }
    }
}
