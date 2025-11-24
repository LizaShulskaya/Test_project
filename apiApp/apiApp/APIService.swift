//
//  APIService.swift
//  apiApp
//
//  Created by LeverX on 10/15/25.
//
import Foundation

class APIService {
    
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
                
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func createNewPost(post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONEncoder().encode(post)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let post = try JSONDecoder().decode(Post.self, from: data)
                completion(.success(post))
                
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func updatePost(post: Post, completion: @escaping (Result<Post, Error>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(post.id)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONEncoder().encode(post)
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let post = try JSONDecoder().decode(Post.self, from: data)
                completion(.success(post))
                
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func deletePost(post: Post, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(post.id)") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }
        
        task.resume()
    }
}
