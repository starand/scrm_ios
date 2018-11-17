//
//  Task.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation

class Task {
    let id: Int
    let time: String
    let dueDate: String
    let title: String
    let desc: String
    let repeat_: Int
    
    init(id: Int, time: String, dueDate: String, title: String, desc: String, _repeat: Int) {
        self.id = id
        self.time = time
        self.dueDate = dueDate
        self.title = title
        self.desc = desc
        self.repeat_ = _repeat
    }
}
