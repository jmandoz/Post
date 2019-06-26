//
//  Post.swift
//  Post
//
//  Created by Jason Mandozzi on 6/24/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation



struct Post: Codable {
    var username: String
    var text: String
    var timestamp: TimeInterval
    
    init(username: String, text: String, timestamp: TimeInterval = Date().timeIntervalSince1970) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
    }
    
    var queryTimestamp: TimeInterval {
        return self.timestamp - 0.00001
    }
    
    var date: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
