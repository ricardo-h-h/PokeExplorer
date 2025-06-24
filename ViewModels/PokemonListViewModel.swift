import Foundation
import Combine

@MainActor
class PokemonListViewModel: ObservableObject {
    
    @Published var pokemonDetails: [PokemonDetail] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let repository: PokemonRepository
    private var currentOffset = 0
    private let limit = 20
    
    init(repository: PokemonRepository = PokemonRepository()) {
        self.repository = repository
        print("✅ [ViewModel] 1. ViewModel inicializado.")
        Task {
            await fetchPokemon()
        }
    }
    
    func loadMorePokemon() {
        guard !isLoading else { return }
        currentOffset += limit
        Task {
            await fetchPokemon(isPaginating: true)
        }
    }
    
    private func fetchPokemon(isPaginating: Bool = false) async {
        print("➡️ [ViewModel] 2. Função fetchPokemon() iniciada.")

        if !isPaginating {
            isLoading = true
        }
        errorMessage = nil
        
        do {
            let listResponse = try await repository.fetchPokemonList(limit: limit, offset: currentOffset)
            print("👍 [ViewModel] 3. Lista de Pokémon recebida. Count: \(listResponse.results.count)")
            
            let details = await fetchDetails(for: listResponse.results)
            print("👍 [ViewModel] 4. Detalhes dos Pokémon recebidos. Count: \(details.count)")
            
            pokemonDetails.append(contentsOf: details)
            print("✅ [ViewModel] 5. Pokémon adicionados à lista. Total agora: \(pokemonDetails.count)")
            
        } catch {
            errorMessage = "Falha ao carregar Pokémon. Tente novamente."
            print("❌ [ViewModel] Erro na função fetchPokemon: \(error.localizedDescription)")
            if isPaginating {
                currentOffset -= limit
            }
        }
        
        isLoading = false
        print("🏁 [ViewModel] 6. Função fetchPokemon() finalizada.")
    }
    
    private func fetchDetails(for items: [PokemonListItem]) async -> [PokemonDetail] {
        await withTaskGroup(of: PokemonDetail?.self) { group in
            var details: [PokemonDetail] = []
            
            for item in items {
                if let id = item.id {
                    group.addTask {
                        return try? await self.repository.fetchPokemonDetail(id: id)
                    }
                }
            }
            
            for await detail in group {
                if let detail = detail {
                    details.append(detail)
                }
            }
            return details.sorted { $0.id < $1.id }
        }
    }
}
