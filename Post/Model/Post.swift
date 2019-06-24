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
    var timestamp: TimeInterval = Date().timeIntervalSince1970
    
    init(username: String, text: String, timestamp: TimeInterval) {
        self.username = username
        self.text = text
        self.timestamp = timestamp
    }
}
