//
//  PostController.swift
//  Post
//
//  Created by Jason Mandozzi on 6/24/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation

class PostController {
    
    let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    
    var posts: [Post] = []
    
    func fetchPosts(reset: Bool = true, completion: @escaping () -> Void) {
        let queryEndInterval = reset ? Date().timeIntervalSince1970 : posts.last?.queryTimestamp ?? Date().timeIntervalSince1970
        let urlParameters = [ "orderBy": "\"timestamp\"", "endAt": "\(queryEndInterval)", "limitToLast": "15", ]
        let queryItems = urlParameters.compactMap( { URLQueryItem(name: $0.key, value: $0.value) } )
        guard let unwrappedURL = baseURL else {completion(); return }
        var urlComponents = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { completion(); return}
        let getterEndpoint = url.appendingPathExtension("json")
        var urlRequest = URLRequest(url: getterEndpoint)
        urlRequest.httpBody = nil
        urlRequest.httpMethod = "GET"
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("\(error.localizedDescription)")
                completion()
                return
            }
            guard let data = data else {completion(); return}
            let jsDecoder = JSONDecoder()
            
            do {
                let postsDictionary = try jsDecoder.decode([String:Post].self, from: data)
                var posts = postsDictionary.compactMap({ $0.value })
                var sortedPosts = posts.sorted(by: { $0.timestamp > $1.timestamp })
                if reset {
                    self.posts = sortedPosts
                } else {
                    self.posts.append(contentsOf: sortedPosts)
                }
                completion()
                
            } catch {
                print(error)
                completion()
                return
            }
        }
        dataTask.resume()
    }
    
    func addNewPostWith(username: String, text: String, completion: @escaping () -> Void) {
        let post = Post(username: username, text: text)
        var postData: Data
        do {
            let jencoder = JSONEncoder()
            postData = try jencoder.encode(post)
            if let baseURL = baseURL {
                let postEndpoint = baseURL.appendingPathExtension("json")
                var urlRequest = URLRequest(url: postEndpoint)
                urlRequest.httpBody = postData
                urlRequest.httpMethod = "POST"
                let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                    if let error = error {
                        print("Error sending data \(error.localizedDescription)")
                        completion()
                        return
                    }
                    if let data = data {
                        print(String(data: data, encoding: .utf8)!)
                        self.fetchPosts {
                            completion()
                            return
                        }
                    }
                }; dataTask.resume()
            }
        } catch {
            print("error encoding \(error.localizedDescription)")
        }
    }
}
