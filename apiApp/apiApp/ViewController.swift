//
//  ViewController.swift
//  apiApp
//
//  Created by LeverX on 10/15/25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView()
    private var posts = [Post]()
    private let apiService = APIService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "Posts"
    
        configureNavBar()
        configureTableView()
        loadPosts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let post = posts[indexPath.row]
        
        cell.textLabel?.text = "\(post.id) \(post.title)"
        cell.detailTextLabel?.text = post.body
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = posts[indexPath.row]
            apiService.deletePost(post: post) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self?.posts.remove(at: indexPath.row)
                        self?.tableView.reloadData()
                    case .failure(let error):
                        print("Error deleting post")
                    }
                }
             
            }
        }
    }
    
    private func loadPosts() {
        apiService.fetchPosts { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let posts):
                    self?.posts = posts
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching posts: \(error)")
                }
            }
        }
    }
    
    @objc private func createNewPost() {
        let post = Post(id: 0, userId: 3, title: "New Post", body: "New New New")
        
        apiService.createNewPost(post: post) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(var post):
                    post.id = (self?.posts.count ?? 0) + 1
                    self?.posts.append(post)
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error creating new post: \(error)")
                }
            }
        }
    }
    
    private func configureTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewPost))
    }
    

}

