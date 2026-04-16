//
//  AuthViewModel.swift
//  Socialcademy
//
//  Created by Adrian Aguirre on 15/04/26.
//

import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var email = ""
    @Published var password = ""
    
    private let authService = AuthService()
    
    init() {
        authService.$isAuthenticated.assign(to: &$isAuthenticated)
    }
    //Method to sign-in users
    func signIn() {
        Task {
            do {
                try await authService.signIn(email: email, password: password)
            } catch {
                print("[AuthViewModel] Cannot sign in: \(error)")
            }
        }
    }

}
