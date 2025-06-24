// Em Persistence/FavoritePokemon.swift
import Foundation
import SwiftData

@Model
final class FavoritePokemon {
    // ID único para o registro de favorito
    @Attribute(.unique)
    var id: UUID
    
    // ID do Pokémon vindo da PokéAPI, para podermos buscá-lo se necessário.
    let pokemonID: Int
    let name: String
    let imageURL: String? // Salvar a URL da imagem economiza chamadas de API
    let favoritedAt: Date // Data em que foi favoritado
    
    // Relação: A qual usuário este favorito pertence?
    var user: User?
    
    init(id: UUID = UUID(), pokemonID: Int, name: String, imageURL: String?, user: User) {
        self.id = id
        self.pokemonID = pokemonID
        self.name = name
        self.imageURL = imageURL
        self.favoritedAt = .now
        self.user = user
    }
}
