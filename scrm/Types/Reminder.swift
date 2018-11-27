//
//  Reminder.swift
//  scrm
//
//  Created by astarodub on 11/26/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation

class Reminder {
    let tid: Int
    let cid: Int
    let time: String
    let title: String
    let body: String
    
    init(task: Int, contact: Int, time: String, title: String, body: String) {
        self.tid = task
        self.cid = contact
        self.time = time
        self.title = title
        self.body = body
    }
}
