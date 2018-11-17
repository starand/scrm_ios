//
//  UserUtils.swift
//  scrm
//
//  Created by astarodub on 10/27/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation

enum LoginRespone {
    case error(String)
    case success(String)
}

class UserUtils {
    class func isUserLoggedIn() -> Bool {
        return false
    }
    
    static var userName = ""
    static var userPassword = ""
    
    class func loginUser(login: String, password: String, handler: @escaping (LoginRespone) -> Void) {
        userName = login
        userPassword = password
        
        NetUtils.login(user: login, pswd: password) { response in
            switch (response) {
            case .error(let message):
                handler(.error(message))
            case .success(let json):
                if
                    let status = json["status"] as? String,
                    let expiration_ = json["expiration"] as? String,
                    let expiration = Int(expiration_) {
                    storeUserData(login: userName, password: userPassword, expiration: expiration)
                    handler(.success(status))
                } else {
                    handler(.error("Incorrect response!"))
                }
            }
        }
    }
    
// User Defaults
    class func storeUserData(login: String, password: String, expiration: Int) {
        let defaults = UserDefaults.standard
        
        defaults.set(login, forKey: "login")
        defaults.set(password, forKey: "password")  
        defaults.set(expiration, forKey: "expiration")
        
        defaults.synchronize()
    }
    
    class func loadUserData() -> (String?, String?, Int) {
        let defaults = UserDefaults.standard
        
        let login = defaults.string(forKey: "login")
        let password = defaults.string(forKey: "password")
        let expiration = defaults.integer(forKey: "expiration")
        
        return (login, password, expiration)
    }
    
    class func storeSessionId(sessionId: String) {
        let defaults = UserDefaults.standard
        defaults.set(sessionId, forKey: "sessionId")
        defaults.synchronize()
    }
    
    class func loadSessionId() -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: "sessionId")
    }
}
