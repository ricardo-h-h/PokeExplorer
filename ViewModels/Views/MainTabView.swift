import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            // Aba 1: Lista de todos os Pokémon
            PokemonListView()
                .tabItem {
                    Label("Pokédex", systemImage: "list.bullet")
                }
            
            // Aba 2: Lista de Favoritos
            // Envolvemos em um NavigationStack para que tenha uma barra de título
            NavigationStack {
                FavoritesListView()
            }
            .tabItem {
                Label("Favoritos", systemImage: "star.fill")
            }
            
            // Futuramente, a sua aba de busca poderia entrar aqui!
        }
    }
}
