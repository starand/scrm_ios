//
//  NetworkUtils.swift
//  scrm
//
//  Created by astarodub on 10/27/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation

enum Response {
    case error(String)
    case success([String: Any])
}

class NetUtils {
    
    static let serverAddress = "https://www.boyclothing.lviv.ua/scrm/m/?check="
    
    static let loginPage = "login"
    static let remindersPage = "reminders"
    
    static let contactsPage = "contact_list"
    static let addContactPage = "add_contact"
    
    static let categoriesPage = "categories"
    static let addCategoryPage = "add_category"

    static let tasksPage = "tasks"
    static let addTaskPage = "add_task"
    static let deleteTaskPage = "delete_task"
    
    static let historyPage = "notes"
    static let addNotePage = "add_note"
    static let deleteNotePage = "delete_note"

    class func executeRequest(urlAddress: String, handler: @escaping (Response) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let url = URL(string: serverAddress + urlAddress)!
        var request = URLRequest(url: url)
        if let sessionId = UserUtils.loadSessionId() {
            request.addValue(sessionId, forHTTPHeaderField: "Cookie")
        }

        let task = session.dataTask(with: request, completionHandler: { (data, response_, error) in
            guard let rawData = data, let response = response_ as? HTTPURLResponse else {
                handler(.error("Network error!"))
                return
            }
            
            if let sessionId = extractSessionId(response) {
                UserUtils.storeSessionId(sessionId: sessionId)
            }

            guard
                let textData = String(data: rawData, encoding: String.Encoding.utf8),
                let jsonData = textData.base64decoded else {
                    handler(.error("Server error!"))
                    return
            }

            Cache.storeToCache(url: urlAddress, content: jsonData)
            print(jsonData)
            do {
                let json = try JSONSerialization.jsonObject(with: jsonData.data(using: .utf8)!, options: [])
                
                guard let root = json as? [String: Any] else {
                    handler(.error("Json error!"))
                    return
                }
                
                if let error = root["error"] as? String {
                    handler(.error(error))
                    return
                }
                
                handler(.success(root))
            } catch {
                handler(.error("Json error."))
            }
        })

        task.resume()
    }
    
    class func extractSessionId(_ response: HTTPURLResponse) -> String? {
        let headers = response.allHeaderFields
        let cookies_ = headers["Set-Cookie"] as? String
        
        if let cookies = cookies_, let stopIndex = cookies.index(of: ";"), let startIndex = cookies.index(of: "=") {
            return cookies.substring(to: stopIndex) //.substring(from: cookies.index(startIndex, offsetBy: 1))
        }
        return nil
    }
   
    class func login(user: String, pswd: String, handler: @escaping (Response) -> Void) {
        let request = "\(loginPage):name=\(user.base64encoded):pswd=\(pswd.base64encoded)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
    }

    class func fetchContacts(handler: @escaping (Response) -> Void) -> String  {
        let request = "\(contactsPage)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
        return request
    }
    
    class func fetchCategories(handler: @escaping (Response) -> Void) -> String {
        let request = "\(categoriesPage)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
        return request
    }
    
    class func fetchTasks(_ contactId: Int, handler: @escaping (Response) -> Void) -> String {
        let id = "\(contactId)"
        let request = "\(tasksPage):contactId=\(id.base64encoded)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
        return request
    }
    
    class func fetchNotes(_ contactId: Int, handler: @escaping (Response) -> Void) -> String {
        let id = "\(contactId)"
        let request = "\(historyPage):contactId=\(id.base64encoded)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
        return request
    }
    
    class func fetchReminders(handler: @escaping (Response) -> Void) {
        let request = "\(remindersPage)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
    }
    
    class func addNote(_ contactId: Int, title: String, desc: String, handler: @escaping (Response) -> Void) {
        let id = "\(contactId)"
        let request = "\(addNotePage):contactId=\(id.base64encoded):title=\(title.base64encoded):desc=\(desc.base64encoded)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
    }
    
    class func deleteNote(_ noteId: Int, contactId: Int, handler: @escaping (Response) -> Void) {
        let id = "\(noteId)", contact = "\(contactId)"
        let request = "\(deleteNotePage):id=\(id.base64encoded):contact=\(contact.base64encoded)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
    }
    
    class func addTask(_ contactId: Int, title: String, desc: String, date: String, time: String, repeat_: Int, remind: Int, handler: @escaping (Response) -> Void) {
        let id = "\(contactId)", repeatId = "\(repeat_)", remindId = "\(remind)"
        let request = "\(addTaskPage):contactId=\(id.base64encoded):title=\(title.base64encoded):desc=\(desc.base64encoded):date=\(date.base64encoded):time=\(time.base64encoded):repeat=\(repeatId.base64encoded):remind=\(remindId.base64encoded)"
        print(request)
        executeRequest(urlAddress: request.base64encoded, handler: handler)
    }
    
    class func deleteTask(_ taskId: Int, contactId: Int, handler: @escaping (Response) -> Void) {
        let id = "\(taskId)", contact = "\(contactId)"
        let request = "\(deleteTaskPage):id=\(id.base64encoded):contact=\(contact.base64encoded)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
    }
    
    class func addContact(name: String, phone: String, sex: String, category: Int, handler: @escaping (Response) -> Void) {
        let catId = "\(category)"
        let request = "\(addContactPage):name=\(name.base64encoded):phone=\(phone.base64encoded):sex=\(sex.base64encoded):cat=\(catId.base64encoded)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
    }
    
    class func addCategory(name: String, desc: String, handler: @escaping (Response) -> Void) {
        let request = "\(addCategoryPage):name=\(name.base64encoded):phone=\(desc.base64encoded)".base64encoded
        executeRequest(urlAddress: request, handler: handler)
    }
    
}

extension String {
    var base64decoded: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    var base64encoded: String {
        return Data(self.utf8).base64EncodedString()
    }
}

extension String {
    func subStr(s: Int, l: Int) -> String { //s=start, l=lenth
        let r = Range(NSRange(location: s, length: l))!
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        
        return String(self[indexRange])
    }
}
