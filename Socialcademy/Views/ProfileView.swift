//
//  ProfileView.swift
//  Socialcademy
//
//  Created by Adrian Aguirre on 15/04/26.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    var body: some View {
        Button("Sign Out", action: {
            try! Auth.auth().signOut()
        })
    }
}
