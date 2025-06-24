import SwiftUI

struct PokemonListView: View {
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn: Bool = true
    @AppStorage("loggedInUsername") private var loggedInUsername: String = ""
    
    @StateObject private var viewModel = PokemonListViewModel()
    
    private let columns = [GridItem(.adaptive(minimum: 120))]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: AppSpacing.medium) {
                    ForEach(viewModel.pokemonDetails) { pokemon in
                        NavigationLink(destination: PokemonDetailView(pokemon: pokemon)) {
                            PokemonCardView(
                                id: pokemon.id,
                                name: pokemon.name,
                                imageURL: pokemon.sprites.other?.officialArtwork?.frontDefault ?? pokemon.sprites.frontDefault
                            )
                            .onAppear {
                                if pokemon.id == viewModel.pokemonDetails.last?.id {
                                    viewModel.loadMorePokemon()
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(AppSpacing.medium)
            }
            .navigationTitle("Pokédex")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: logout) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(AppColor.primary)
                    }
                }
            }
            .overlay {
                if viewModel.isLoading && viewModel.pokemonDetails.isEmpty {
                    ProgressView("Carregando...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(AppColor.primary)
                        .scaleEffect(1.5)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
            .alert("Erro", isPresented: .constant(viewModel.errorMessage != nil), actions: {
                Button("OK") { viewModel.errorMessage = nil }
            }, message: {
                Text(viewModel.errorMessage ?? "Ocorreu um erro desconhecido.")
            })
        }
    }
    
    private func logout() {
        isUserLoggedIn = false
        loggedInUsername = ""
    }
}
