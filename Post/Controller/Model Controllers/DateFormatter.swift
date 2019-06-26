//
//  DateFormatter.swift
//  Post
//
//  Created by Jason Mandozzi on 6/24/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

extension Date {
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.timeZone = .current
        
        return formatter.string(from: self)
    }
}
