//
//  SocialcademyApp.swift
//  Socialcademy
//
//  Created by Adrian Aguirre on 06/03/26.
//

import SwiftUI
import FirebaseCore

@main
struct SocialcademyApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            PostsList()
        }
    }
}
