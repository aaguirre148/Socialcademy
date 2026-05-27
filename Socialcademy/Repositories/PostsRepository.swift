//
//  PostsRepository.swift
//  Socialcademy
//
//  Created by Adrian Aguirre on 15/03/26.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift

protocol PostsRepositoryProtocol {
    func fetchAllPosts() async throws -> [Post]
    func fetchFavoritePosts() async throws -> [Post]
    func create(_ post: Post) async throws
    func delete(_ post: Post) async throws
    func favorite(_ post: Post) async throws
    func unfavorite(_ post: Post) async throws
    var user: User { get }
    func fetchPosts(by author: User) async throws -> [Post]
}

extension PostsRepositoryProtocol {
    func canDelete(_ post: Post) -> Bool {
        post.author.id == user.id
    }
}

#if DEBUG
struct PostsRepositoryStub: PostsRepositoryProtocol {
    var user = User.testUser
    let state: Loadable<[Post]>
    
    func fetchAllPosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func fetchFavoritePosts() async throws -> [Post] {
        return try await state.simulate()
    }
    
    func create(_ post: Post) async throws {}
    
    func delete(_ post: Post) async throws {}
    
    func favorite(_ post: Post) async throws {}
        
    func unfavorite(_ post: Post) async throws {}
    
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await state.simulate()
    }
}
#endif

struct PostsRepository: PostsRepositoryProtocol {
    let user: User
    let postsReference = Firestore.firestore().collection("posts_v2")
    let favoritesReference = Firestore.firestore().collection("favorites")
    
    //This method fetches documents from the posts collection in reverse-chronological order, and returns them as an array of Post instances.
    func fetchAllPosts() async throws -> [Post] {
        return try await fetchPosts(from: postsReference)
    }
    //Method to fetch post by a given author
    func fetchPosts(by author: User) async throws -> [Post] {
        return try await fetchPosts(from: postsReference.whereField("author.id", isEqualTo: author.id))
    }
    func fetchFavoritePosts() async throws -> [Post] {
        let favorites = try await fetchFavorites()
        guard !favorites.isEmpty else { return [] }
        return try await postsReference
            .whereField("id", in: favorites.map(\.uuidString))
            .order(by: "timestamp", descending: true)
            .getDocuments(as: Post.self)
            .map { post in
                post.setting(\.isFavorite, to: true)
            }
    }
    //This is a private function that is common for the fetchAllPosts and fetchFavoritePosts
    func create(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.setData(from: post)
    }
    
    func delete(_ post: Post) async throws {
        let document = postsReference.document(post.id.uuidString)
        try await document.delete()
    }
    
    func favorite(_ post: Post) async throws {
        let favorite = Favorite(postID: post.id, userID: user.id)
        let document = favoritesReference.document(favorite.id)
        try await document.setData(from: favorite)
    }
    
    func unfavorite(_ post: Post) async throws {
        let favorite = Favorite(postID: post.id, userID: user.id)
        let document = favoritesReference.document(favorite.id)
        try await document.delete()
    }
}

private extension PostsRepository {
    func fetchPosts(from query: Query) async throws -> [Post] {
        let (posts, favorites) = try await (
            query.order(by: "timestamp", descending: true).getDocuments(as: Post.self),
            fetchFavorites()
        )
        return posts.map { post in
            post.setting(\.isFavorite, to: favorites.contains(post.id))
        }
    }
    
    func fetchFavorites() async throws -> [Post.ID] {
        return try await favoritesReference
            .whereField("userID", isEqualTo: user.id)
            .getDocuments(as: Favorite.self)
            .map(\.postID)
    }
    
    struct Favorite: Identifiable, Codable {
        var id: String {
                postID.uuidString + "-" + userID
            }
        let postID: Post.ID
        let userID: User.ID
    }
}

private extension Post {
    func setting<T>(_ property: WritableKeyPath<Post, T>, to newValue: T) -> Post {
        var post = self
        post[keyPath: property] = newValue
        return post
    }
}
