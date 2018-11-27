//
//  DateUtils.swift
//  scrm
//
//  Created by astarodub on 11/26/18.
//  Copyright © 2018 StarAnd software. All rights reserved.
//

import Foundation

extension Date {
    static func fromMysql(_ dateString: String) -> Date? {
        let fmt = DateFormatter()
        
        fmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
        fmt.timeZone = TimeZone.current        
        fmt.locale = Locale(identifier: "en_US_POSIX")
        
        return fmt.date(from: dateString)
    }
}
