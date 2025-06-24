import Foundation

// Modelo principal para a lista de Pokémon.
struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
    let next: String?
}

struct PokemonListItem: Codable, Identifiable {
    let name: String
    let url: String
    
    var id: Int? {
        return Int(url.split(separator: "/").last?.description ?? "0")
    }
}

// Modelo para os detalhes de um Pokémon específico.
struct PokemonDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let sprites: PokemonSprites
    let types: [PokemonTypeEntry]
    let abilities: [PokemonAbilityEntry]
    let moves: [PokemonMoveEntry]
}

// Modelos aninhados para as propriedades do Pokémon.
struct PokemonSprites: Codable {
    let frontDefault: String?
    let other: OtherSprites?
}

struct OtherSprites: Codable {
    let officialArtwork: OfficialArtwork?
    
    enum CodingKeys: String, CodingKey {
        case officialArtwork = "official-artwork"
    }
}

struct OfficialArtwork: Codable {
    let frontDefault: String?
}

struct PokemonTypeEntry: Codable, Identifiable {
    var id: UUID { UUID() }
    let slot: Int
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
    let url: String
}

struct PokemonAbilityEntry: Codable, Identifiable {
    var id: UUID { UUID() }
    let ability: PokemonAbility
}

struct PokemonAbility: Codable {
    let name: String
}

struct PokemonMoveEntry: Codable, Identifiable {
    var id: UUID { UUID() }
    let move: PokemonMove
}

struct PokemonMove: Codable {
    let name: String
}
