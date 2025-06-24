import SwiftUI
import SwiftData

struct FavoritesListView: View {
    // Mantemos o AppStorage para saber qual usuário está logado.
    @AppStorage("loggedInUsername") private var loggedInUsername: String = ""
    
    // Usamos @Query para buscar TODOS os favoritos do banco de dados local.
    @Query(sort: \FavoritePokemon.favoritedAt, order: .reverse)
    private var allFavorites: [FavoritePokemon]
    
    // Esta propriedade computada filtra a lista para o usuário logado.
    private var filteredFavorites: [FavoritePokemon] {
        allFavorites.filter { $0.user?.username == loggedInUsername }
    }

    private let columns = [GridItem(.adaptive(minimum: 120))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: AppSpacing.medium) {
                // Iteramos sobre a lista já filtrada
                ForEach(filteredFavorites) { favorite in
                    
                    // --- ALTERAÇÃO APLICADA AQUI ---
                    // O NavigationLink agora aponta para o nosso novo PokemonDetailFetcher,
                    // passando apenas o ID necessário para a busca.
                    NavigationLink(destination: PokemonDetailFetcher(pokemonID: favorite.pokemonID)) {
                        PokemonCardView(
                            id: favorite.pokemonID,
                            name: favorite.name,
                            imageURL: favorite.imageURL
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(AppSpacing.medium)
        }
        .navigationTitle("Favoritos")
        .overlay {
            // A lógica de overlay também usa a lista filtrada.
            if filteredFavorites.isEmpty {
                ContentUnavailableView("Sem Favoritos",
                                       systemImage: "star.slash",
                                       description: Text("Você ainda não favoritou nenhum Pokémon."))
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [User.self, FavoritePokemon.self])
}
