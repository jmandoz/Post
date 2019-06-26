//
//  PostListViewController.swift
//  Post
//
//  Created by Jason Mandozzi on 6/24/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postController = PostController()
    
    var refreshControl = UIRefreshControl()
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.postTableView.reloadData()
        }
    }
    
    @objc func refreshControlPulled() {
        postController.fetchPosts {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            self.reloadTableView()
        }
    }

    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.postTableView.delegate = self
        self.postTableView.dataSource = self
        self.postTableView.estimatedRowHeight = 45
        self.postTableView.rowHeight = UITableView.automaticDimension
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        postController.fetchPosts {
            self.reloadTableView()
        }
    }
    
    @IBAction func addPostButton(_ sender: Any) {
        presentNewPostAlert()
    }
    
    func presentNewPostAlert() {
        //creating an alert constant the is an instance of UIAlertController
        let alert = UIAlertController(title: "new post", message: "create a new post" , preferredStyle: UIAlertController.Style.alert)
        //creating the text fields for the alerts and adding placeholders
        //Username
        alert.addTextField { (textField) in
            textField.placeholder = "Enter your username"
        }
        //Message
        alert.addTextField { (textField) in
            textField.placeholder = "Enter Message"
        }
        //Adding an alert action that will allow us to use the text that is entered in the textfield
        alert.addAction(UIAlertAction(title: "Agreed", style: .default, handler: { [weak alert] (_) in
            //getting the index of the first textfield [0] and assigning the username textfield.text
            guard let textField = alert?.textFields?[0], let usernameText = textField.text else {return}
            //getting the index of the second textfield [1] and assigning the message textfield.text
            guard let textField2 = alert?.textFields?[1], let messageText = textField2.text else {return}
            //adding our post using the add new post function from our post controller and reloading the tableview
            self.postController.addNewPostWith(username: usernameText, text: messageText, completion: {
                self.reloadTableView()
            })
        }))
        //Cancel button
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        
        let post = postController.posts[indexPath.row]
        
        let date = Date(timeIntervalSince1970: post.timestamp)
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username) \(date.stringValue())"
        
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
