import SwiftUI

struct PokemonDetailFetcher: View {
    let pokemonID: Int
    private let repository = PokemonRepository()

    @State private var viewState: ViewState = .loading
    
    enum ViewState {
        case loading
        case loaded(PokemonDetail)
        case error(String)
    }

    var body: some View {
        switch viewState {
        case .loading:
            ProgressView("Carregando Detalhes...")
                .navigationTitle("")
                .task {
                    await fetchDetails()
                }
                
        case .loaded(let pokemonDetail):
            // ESTA CHAMADA AGORA É VÁLIDA porque corresponde ao init simples
            PokemonDetailView(pokemon: pokemonDetail)
            
        case .error(let errorMessage):
            VStack {
                Text("Erro ao Carregar")
                    .font(.title)
                    .padding(.bottom)
                Text(errorMessage)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func fetchDetails() async {
        do {
            let detail = try await repository.fetchPokemonDetail(id: pokemonID)
            viewState = .loaded(detail)
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }
}
