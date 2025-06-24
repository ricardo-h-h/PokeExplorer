import Foundation
import SwiftData
import SwiftUI

@MainActor
class PokemonDetailViewModel: ObservableObject {
    
    let pokemon: PokemonDetail
    @Published var isFavorite: Bool = false
    
    @AppStorage("loggedInUsername") private var loggedInUsername: String = ""
    
    init(pokemon: PokemonDetail) {
        self.pokemon = pokemon
        print("✅ [DetailViewModel] ViewModel para '\(pokemon.name)' inicializado.")
    }
    
    func checkFavoriteStatus(context: ModelContext) {
        print("➡️ [DetailViewModel] 1. Checando status de favorito para '\(pokemon.name)'...")
        guard !loggedInUsername.isEmpty,
              let user = FavoritesService.fetchCurrentUser(username: loggedInUsername, context: context) else {
            print("⚠️ [DetailViewModel] Não foi possível encontrar o usuário logado para checar favoritos.")
            return
        }
        
        self.isFavorite = FavoritesService.isFavorite(pokemonID: pokemon.id, for: user)
        print("👍 [DetailViewModel] 2. Status inicial de isFavorite definido para: \(self.isFavorite)")
    }
    
    // VERSÃO FINAL E DEFINITIVA
    func toggleFavoriteStatus(context: ModelContext) {
        print("➡️ [DetailViewModel] 3. Botão de favorito tocado!")
        guard let user = FavoritesService.fetchCurrentUser(username: loggedInUsername, context: context) else {
            print("⚠️ [DetailViewModel] Não foi possível encontrar o usuário logado para ATUALIZAR favoritos.")
            return
        }
        
        // Notifica manualmente a View que uma mudança está prestes a ocorrer.
        // Isso resolve problemas raros onde a atualização automática não funciona.
        objectWillChange.send()
        
        // Executa a ação no banco de dados (adicionar/remover)
        FavoritesService.toggleFavorite(pokemon: pokemon, for: user, context: context)
        
        // Lê o estado DIRETAMENTE do banco de dados para garantir a verdade.
        self.isFavorite = FavoritesService.isFavorite(pokemonID: pokemon.id, for: user)
        print("👍 [DetailViewModel] 4. Estado RE-CHECADO depois da ação: \(isFavorite)")
    }
}
