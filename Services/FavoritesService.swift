import Foundation
import SwiftData

struct FavoritesService {
    
    static func fetchCurrentUser(username: String, context: ModelContext) -> User? {
        print("➡️ [Service] Procurando usuário: '\(username)'")
        let predicate = #Predicate<User> { $0.username == username }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        
        do {
            let user = try context.fetch(fetchDescriptor).first
            if user != nil {
                print("👍 [Service] Usuário '\(username)' encontrado.")
            } else {
                print("⚠️ [Service] Usuário '\(username)' NÃO encontrado no banco.")
            }
            return user
        } catch {
            print("❌ [Service] Falha ao buscar usuário: \(error.localizedDescription)")
            return nil
        }
    }
    
    static func isFavorite(pokemonID: Int, for user: User) -> Bool {
        let isFav = user.favorites?.contains(where: { $0.pokemonID == pokemonID }) ?? false
        print("➡️ [Service] Checando se Pokémon #\(pokemonID) é favorito para '\(user.username)': \(isFav)")
        return isFav
    }
    
    static func toggleFavorite(pokemon: PokemonDetail, for user: User, context: ModelContext) {
        let pokemonID = pokemon.id
        
        if let existingFavorite = user.favorites?.first(where: { $0.pokemonID == pokemonID }) {
            print("➡️ [Service] Pokémon #\(pokemonID) é favorito. Removendo...")
            context.delete(existingFavorite)
        } else {
            print("➡️ [Service] Pokémon #\(pokemonID) não é favorito. Adicionando...")
            let newFavorite = FavoritePokemon(
                pokemonID: pokemon.id,
                name: pokemon.name,
                imageURL: pokemon.sprites.other?.officialArtwork?.frontDefault ?? pokemon.sprites.frontDefault,
                user: user
            )
            // SwiftData é inteligente e geralmente adiciona `newFavorite` à relação `user.favorites` automaticamente.
            context.insert(newFavorite)
        }
        
        do {
            try context.save()
            print("✅ [Service] Banco de dados salvo com sucesso!")
        } catch {
            print("❌ [Service] ERRO AO SALVAR O BANCO DE DADOS: \(error.localizedDescription)")
        }
    }
}
