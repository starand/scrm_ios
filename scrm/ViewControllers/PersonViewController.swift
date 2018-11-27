//
//  PersonViewController.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    
    static var personId: Int = 0

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var phoneImage: UIImageView!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var categoryImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PersonViewController.personId >= 0 {
            loadPersonData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    func loadPersonData() {
        let contacts = PeopleViewController.contacts
        let idx = PersonViewController.personId
        let categories = ViewController.categories
        
        // find person
        for person in PeopleViewController.contacts {
            if person.id == PersonViewController.personId {
                nameLabel.text = person.name
                phoneLabel.text = person.phone
                mailLabel.text = person.mail
                categoryLabel.text = categories.count > person.cat ? categories[person.cat].name : "Not set"
                phoneImage.image = UIImage(named: "phone.png")
                emailImage.image = UIImage(named: "email.png")
                categoryImage.image = UIImage(named: "category.png")
            }
        }
    }
}
