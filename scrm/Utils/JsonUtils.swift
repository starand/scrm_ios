//
//  JsonUtils.swift
//  scrm
//
//  Created by astarodub on 11/17/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation


class JsonUtils {
    
    class func parseCategories(_ json: [String: Any]) -> [Category] {
        var result: [Category] = []
        
        guard let categories = json["categories"] as? [Any] else {
            return result
        }

        for _item in categories {
            if let item = _item as? [String: Any],
                let _id = item["id"] as? String, let id = Int(_id),
                let name = item["name"] as? String,
                let desc = item["desc"] as? String {
                
                let category = Category(id: id, name: name, desc: desc)
                result.append(category)
            }
        }

        return result
    }
    
    class func parseContacts(_ json: [String: Any]) -> [Contact] {
        var result: [Contact] = []
        
        guard let contacts = json["contacts"] as? [Any] else {
            return result
        }
        
        for _item in contacts {
            if let item = _item as? [String: Any],
                let _id = item["id"] as? String, let id = Int(_id),
                let _cat = item["cat"] as? String, let cat = Int(_cat),
                let name = item["name"] as? String,
                let phone = item["phone"] as? String,
                let sex = item["sex"] as? String,
                let mail = item["mail"] as? String,
                let country = item["country"] as? String,
                let city = item["city"] as? String,
                let birthday = item["birthday"] as? String {
                
                let contact = Contact(id: id, name: name, phone: phone, cat: cat, sex: sex, mail: mail, country: country, city: city, birthday: birthday)
                result.append(contact)
            }
        }
        
        return result
    }
    
    class func parseTasks(_ json: [String: Any]) -> [Task] {
        var result: [Task] = []
        
        guard let tasks = json["tasks"] as? [Any] else {
            return result
        }
        
        for _item in tasks {
            if let item = _item as? [String: Any],
                let _id = item["id"] as? String, let id = Int(_id),
                let _repeat = item["repeat"] as? String, let repeat_ = Int(_repeat),
                let time = item["time"] as? String,
                let dueDate = item["due_date"] as? String,
                let title = item["title"] as? String,
                let desc = item["desc"] as? String {
                
                let task = Task(id: id, time: time, dueDate: dueDate, title: title, desc: desc, _repeat: repeat_)
                result.append(task)
            }
        }
        
        return result
    }
    
    class func parseNotes(_ json: [String: Any]) -> [Note] {
        var result: [Note] = []
        
        guard let items = json["notes"] as? [Any] else {
            return result
        }
        
        for _item in items {
            if let item = _item as? [String: Any],
                let _id = item["id"] as? String, let id = Int(_id),
                let time = item["time"] as? String,
                let message = item["message"] as? String,
                let title = item["title"] as? String {
                
                let task = Note(id: id, time: time, message: message, title: title)
                result.append(task)
            }
        }
        
        return result
    }
    
    class func parseReminders(_ json: [String: Any]) -> [Reminder] {
        var result: [Reminder] = []
        
        guard let reminders = json["reminders"] as? [Any] else {
            return result
        }
        
        for _item in reminders {
            if let item = _item as? [String: Any],
                let _id = item["tid"] as? String, let tid = Int(_id),
                let _cid = item["cid"] as? String, let cid = Int(_cid),
                let title = item["title"] as? String,
                let body = item["desc"] as? String,
                let time = item["time"] as? String {
                
                let reminder = Reminder(task: tid, contact: cid, time: time, title: title, body: body)
                result.append(reminder)
            }
        }
        
        return result
    }
}
