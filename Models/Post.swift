//
//  Post.swift
//  Socialcademy
//
//  Created by Adrian Aguirre on 09/03/26.
//

import Foundation

struct Post: Identifiable {
    var title: String
    var content: String
    var authorName: String
    let timestamp: Date = Date()
    let id: UUID = UUID()
}

extension Post {
    static let testPost = Post(
        title: "Lorem ipsum",
        content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
        authorName: "Jamie Harris"
    )
}
