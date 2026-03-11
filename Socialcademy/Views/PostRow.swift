//
//  PostRow.swift
//  Socialcademy
//
//  Created by Adrian Aguirre on 09/03/26.
//

import SwiftUI

struct PostRow: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack{
                Text(post.authorName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text(post.timestamp.formatted(date: .abbreviated, time: .omitted)) // ".formatted" method used to display date as string
                    .font(.caption)
            }
            .foregroundColor(.gray)
                Text(post.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(post.content)
        }
        .padding(.vertical)
    }
}

struct PostRow_Previews: PreviewProvider { //POR QUE FUE NECESARIO AGREGAR ESTO PARA EL PREVIEW??
    static var previews: some View {
        List {
            PostRow(post: Post.testPost)
        }
    }
}
