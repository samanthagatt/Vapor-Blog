//
//  File.swift
//  
//
//  Created by Samantha Gatt on 5/27/20.
//

import Foundation

extension DateFormatter {
    static var year: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y"
        return formatter
    }()
}
