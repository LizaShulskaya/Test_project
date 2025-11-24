//
//  Post.swift
//  apiApp
//
//  Created by LeverX on 10/15/25.
//

struct Post: Codable {
    var id: Int
    let userId: Int
    let title: String
    let body: String
}

