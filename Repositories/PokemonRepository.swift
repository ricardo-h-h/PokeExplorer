import Foundation

enum APIEndpoint {
    static let baseURL = "https://pokeapi.co/api/v2/"
    
    case pokemonList(limit: Int, offset: Int)
    case pokemonDetail(id: Int)
    
    var url: URL? {
        switch self {
        case .pokemonList(let limit, let offset):
            return URL(string: "\(APIEndpoint.baseURL)pokemon?limit=\(limit)&offset=\(offset)")
        case .pokemonDetail(let id):
            return URL(string: "\(APIEndpoint.baseURL)pokemon/\(id)/")
        }
    }
}

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

class PokemonRepository {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchPokemonList(limit: Int = 20, offset: Int = 0) async throws -> PokemonListResponse {
        guard let url = APIEndpoint.pokemonList(limit: limit, offset: offset).url else {
            throw APIError.invalidURL
        }
        return try await performRequest(url: url)
    }
    
    func fetchPokemonDetail(id: Int) async throws -> PokemonDetail {
        guard let url = APIEndpoint.pokemonDetail(id: id).url else {
            throw APIError.invalidURL
        }
        return try await performRequest(url: url)
    }
    
    private func performRequest<T: Decodable>(url: URL) async throws -> T {
        do {
            print("➡️ [Repository] 1. Tentando buscar URL: \(url.absoluteString)")
            
            let (data, response) = try await session.data(for: URLRequest(url: url))
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ [Repository] 2. Erro: Resposta inválida. Status Code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                throw APIError.invalidResponse
            }
            
            print("👍 [Repository] 2. Resposta recebida com sucesso (Status 200).")
            
            do {
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedObject = try decoder.decode(T.self, from: data)
                print("✅ [Repository] 3. Decodificação do JSON feita com sucesso!")
                return decodedObject
            } catch {
                print("❌ [Repository] 3. Erro na decodificação do JSON: \(error)")
                throw APIError.decodingError(error)
            }
        } catch {
            print("❌ [Repository] Erro geral na requisição: \(error)")
            throw APIError.requestFailed(error)
        }
    }
}
