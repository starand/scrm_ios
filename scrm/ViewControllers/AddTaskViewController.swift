//
//  AddTaskViewController.swift
//  scrm
//
//  Created by astarodub on 11/26/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    @IBOutlet weak var titleTextBox: UITextField!
    @IBOutlet weak var dateTextBox: UITextField!
    @IBOutlet weak var timeTextBox: UITextField!
    @IBOutlet weak var repeatTextBox: UITextField!
    @IBOutlet weak var remindTextBox: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    
    let repeatTypes = ["No repeat", "Daily", "Weekly", "Beweekly", "Monthly", "Yearly"]
    let remindTypes = ["No remind", "15 mins", "30 mins", "1 hour", "2 hours", "6 hours", "One day"]
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        repeatTextBox.loadDropdownData(data: repeatTypes)
        remindTextBox.loadDropdownData(data: remindTypes)

        setupDatePicker()
        setupTimePicker()
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        dateTextBox.inputView = datePicker
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));

        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        dateTextBox.inputAccessoryView = toolbar
    }
    
    @objc func doneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTextBox.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    func setupTimePicker() {
        timePicker.datePickerMode = .time
        timeTextBox.inputView = timePicker
        
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton, spaceButton, cancelButton], animated: false)
        timeTextBox.inputAccessoryView = toolbar
    }
    
    @objc func doneTimePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        timeTextBox.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func addTaskClicked(_ sender: Any) {
        guard
            let title = titleTextBox.text,
            let desc = descTextView.text,
            let date = dateTextBox.text,
            let time = timeTextBox.text,
            let repeat_ = repeatTextBox.text,
            let remind = remindTextBox.text
        else {
                self.showAlertMessage(title: "Error", msg: "Title not found")
                return
        }
        
        var repeatType = 0
        if let index = repeatTypes.index(of: repeat_) {
            repeatType = index
        }
        
        var remindType = 0
        if let index = remindTypes.index(of: remind) {
            remindType = index
        }
        
        NetUtils.addTask(PersonViewController.personId, title: title, desc: desc, date: date, time: time, repeat_: repeatType, remind: remindType) { response in
            switch response {
            case .error(let message): self.showAlertMessage(title: "Error", msg: message)
            case .success(_): self.performSegue("showTasksSegue")
            }
        }
    }
}
