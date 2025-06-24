import Foundation
import SwiftData

enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case usernameTaken
    case passwordMismatch
    case unexpectedError
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Nome de usuário ou senha inválidos."
        case .usernameTaken:
            return "Este nome de usuário já está em uso."
        case .passwordMismatch:
            return "As senhas não coincidem."
        case .unexpectedError:
            return "Ocorreu um erro inesperado."
        }
    }
}

struct AuthService {
    
    static func register(username: String, passwordHash: String, in context: ModelContext) throws {
        let predicate = #Predicate<User> { $0.username == username }
        let descriptor = FetchDescriptor(predicate: predicate)
        
        let existingUsers = try context.fetch(descriptor)
        if !existingUsers.isEmpty {
            throw AuthError.usernameTaken
        }
        
        let newUser = User(username: username, passwordHash: passwordHash)
        context.insert(newUser)
        try context.save()
    }
    
    static func login(username: String, passwordHash: String, in context: ModelContext) throws {
        print("➡️ [AuthService] 1. Tentando logar com o usuário: '\(username)'")
        
        let predicate = #Predicate<User> { $0.username == username }
        let fetchDescriptor = FetchDescriptor(predicate: predicate)
        
        let users = try context.fetch(fetchDescriptor)
        print("➡️ [AuthService] 2. Usuários encontrados com este nome: \(users.count)")
        
        guard let user = users.first, user.passwordHash == passwordHash else {
            print("❌ [AuthService] 3. Falha no Guard: O usuário não existe ou a senha está incorreta.")
            throw AuthError.invalidCredentials
        }
        
        print("✅ [AuthService] 3. Login bem-sucedido para o usuário: '\(user.username)'")
    }
}
