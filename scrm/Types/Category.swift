//
//  Category.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation


class Category {
    let id: Int
    let name: String
    let desc: String
    
    init(id: Int, name: String, desc: String) {
        self.id = id
        self.name = name
        self.desc = desc
    }
}
