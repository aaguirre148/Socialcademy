//
//  PostsViewModel.swift
//  Socialcademy
//
//  Created by Adrian Aguirre on 15/03/26.
//

import Combine

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts = [Post.testPost]
    
    func makeCreateAction() -> NewPostForm.CreateAction {
        return { [weak self] post in
            try await PostsRepository.create(post)
            self?.posts.insert(post, at: 0)
        }
    }
}
