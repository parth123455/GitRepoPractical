//
//  Extensions.swift
//  GitRepoPractical
//
//  Created by Parth gondaliya on 01/12/24.
//

import Foundation

extension Date {
    func toFormattedString(format: String = "MMM d, yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
