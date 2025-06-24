// Em PokeExplorerApp.swift
import SwiftUI
import SwiftData

@main
struct PokeExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            // Mude de PokemonListView() para ContentView()
            ContentView()
        }
        .modelContainer(for: [User.self, FavoritePokemon.self])
    }
}

