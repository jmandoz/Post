//
//  PostController.swift
//  Post
//
//  Created by Jason Mandozzi on 6/24/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

class PostController {
    
    static let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    
    static var posts: [Post] = []
    
    static func fetchPosts(completion: @escaping () -> Void) {
        guard let url = baseURL else {completion(); return }
        let getterEndpoint = url.appendingPathExtension("json")
        var urlRequest = URLRequest(url: getterEndpoint)
        urlRequest.httpBody = nil
        urlRequest.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            do {
                guard let data = data else {completion(); return}
                let jsDecoder = JSONDecoder()
                let postsDictionary = try jsDecoder.decode([String:Post].self, from: data)
                var posts = postsDictionary.compactMap({ $0.value })
                posts.sort(by: { $0.timestamp > $1.timestamp })
                posts = self.posts
                completion()
                
            } catch {
                print(error)
                completion()
                return
            }
        }
    }
    
}
