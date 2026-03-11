//
//  PostsList.swift
//  Socialcademy
//
//  Created by Adrian Aguirre on 09/03/26.
//

import SwiftUI

struct PostsList: View {
    private var posts = [Post.testPost]
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            List(posts) { post in
                if searchText.isEmpty || post.contains(searchText) { //si se hace la búsqueda se muestra la vista completa.
                    PostRow(post: post)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Posts")
        }
    }
}

#Preview {
    PostsList()
}
