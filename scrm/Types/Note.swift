//
//  Note.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation

class Note {
    let id: Int
    let time: String
    let message: String
    let title: String
    
    init(id: Int, time: String, message: String, title: String) {
        self.id = id
        self.time = time
        self.message = message
        self.title = title
    }
}
