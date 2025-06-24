import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var username: String
    var passwordHash: String
    var joinedAt: Date
    
    @Relationship(deleteRule: .cascade) var favorites: [FavoritePokemon]?
    
    init(username: String, passwordHash: String) {
        self.username = username
        self.passwordHash = passwordHash
        self.joinedAt = .now
    }
}
