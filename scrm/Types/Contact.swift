//
//  Contact.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation

class Contact {
    let id: Int
    let name: String
    let phone: String
    let cat: Int
    let sex: String
    let mail: String
    let country: String
    let city: String
    let birthday: String
    
    init(id: Int, name: String, phone: String, cat: Int, sex: String,
         mail: String, country: String, city: String, birthday: String) {
        self.id = id
        self.name = name
        self.phone = phone
        self.cat = cat
        self.sex = sex
        self.mail = mail
        self.country = country
        self.city = city
        self.birthday = birthday
    }    
}
