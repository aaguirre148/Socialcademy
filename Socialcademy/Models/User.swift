//
//  User.swift
//  Socialcademy
//
//  Created by Adrian Aguirre on 21/04/26.
//

import Foundation

struct User: Identifiable, Equatable, Codable {
    var id: String
    var name: String
}

extension User {
    static let testUser = User(id: "", name: "Jamie Harris")
}
