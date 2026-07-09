//
//  ErrorHandler.swift
//  Socialcademy
//
//  Created by Adrian Aguirre on 12/05/26.
//

//import Foundation
@MainActor
protocol StateManager: AnyObject {
    var error: Error? { get set }
    var isWorking: Bool { get set }
}

extension StateManager {
    func withErrorHandlingTask(perform action: @escaping () async throws -> Void) {
        Task {
            do {
                try await action()
            } catch {
                print("[\(Self.self)] Error: \(error)")
                self.error = error
            }
        }
    }
}
