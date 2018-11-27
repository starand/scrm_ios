//
//  Cache.swift
//  scrm
//
//  Created by astarodub on 11/26/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation

class Cache {
    class func loadFromCache(url: String) -> [String: Any]? {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
     
        let file = dir.appendingPathComponent(url)
        
        do {
            let jsonData = try String(contentsOf: file, encoding: .utf8)
            let json = try JSONSerialization.jsonObject(with: jsonData.data(using: .utf8)!, options: [])
            if let root = json as? [String: Any] {
                return root
            }
        } catch {
        }
        return nil
    }
    
    class func storeToCache(url: String, content: String) {
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        let file = dir.appendingPathComponent(url)
        
        do {
            try content.write(to: file, atomically: true, encoding: .utf8)
        } catch {
            /* error handling here */
        }
    }
}
