//
//  Date.swift
//  ATPD
//
//  Created by Francisco F on 3/17/23.
//

import Foundation

extension Date {
    func toString(withFormat format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        
        return formatter.string(from: self)
    }
}
