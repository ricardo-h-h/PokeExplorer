import SwiftUI

// MARK: - Layout para Telas Largas (iPad / iPhone em Modo Paisagem)
struct PokemonDetailHorizontalLayout: View {
    @ObservedObject var viewModel: PokemonDetailViewModel
    
    var body: some View {
        HStack {
            Spacer()
            
            HStack(alignment: .top, spacing: AppSpacing.large) {
                AsyncImage(
                    url: URL(string: viewModel.pokemon.sprites.other?.officialArtwork?.frontDefault ?? viewModel.pokemon.sprites.frontDefault ?? ""),
                    transaction: Transaction(animation: .easeInOut(duration: 0.5))
                ) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFit()
                    case .failure:
                        Image(systemName: "wifi.slash").font(.largeTitle).foregroundColor(.secondary)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: 350)
                .padding()
                .background(AppColor.surface)
                .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: AppSpacing.medium) {
                    Text(viewModel.pokemon.name.capitalized)
                        .font(AppFont.pokemonTitle())
                    Text(String(format: "#%03d", viewModel.pokemon.id))
                        .font(.title2).foregroundColor(.secondary)
                    HStack {
                        ForEach(viewModel.pokemon.types) { typeEntry in
                            Text(typeEntry.type.name.uppercased()).font(AppFont.pokemonDetail()).padding(.horizontal, 12).padding(.vertical, 6).background(Color.gray.opacity(0.2)).cornerRadius(12)
                        }
                    }
                    HStack(spacing: AppSpacing.large) {
                        StatView(name: "Peso", value: "\(Double(viewModel.pokemon.weight) / 10.0) kg")
                        StatView(name: "Altura", value: "\(Double(viewModel.pokemon.height) / 10.0) m")
                    }
                    InfoSectionView(title: "Habilidades", items: viewModel.pokemon.abilities.map { $0.ability.name.capitalized })
                    InfoSectionView(title: "Principais Movimentos", items: viewModel.pokemon.moves.prefix(5).map { $0.move.name.capitalized })
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: 1000)
            
            Spacer()
        }
    }
}

// MARK: - Layout para Telas Estreitas (iPhone em Modo Retrato)
struct PokemonDetailVerticalLayout: View {
    @ObservedObject var viewModel: PokemonDetailViewModel
    
    var body: some View {
        VStack(spacing: AppSpacing.medium) {
            AsyncImage(
                url: URL(string: viewModel.pokemon.sprites.other?.officialArtwork?.frontDefault ?? viewModel.pokemon.sprites.frontDefault ?? ""),
                transaction: Transaction(animation: .easeInOut(duration: 0.5))
            ) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFit().frame(maxWidth: 300)
                case .failure:
                    Image(systemName: "wifi.slash").font(.largeTitle).foregroundColor(.secondary).frame(width: 300, height: 300)
                case .empty:
                    ProgressView().frame(width: 300, height: 300)
                @unknown default:
                    EmptyView()
                }
            }
            .padding()
            .background(AppColor.surface)
            .cornerRadius(16)
            
            Text(viewModel.pokemon.name.capitalized)
                .font(AppFont.pokemonTitle())
            Text(String(format: "#%03d", viewModel.pokemon.id))
                .font(.title2).foregroundColor(.secondary)
            HStack {
                ForEach(viewModel.pokemon.types) { typeEntry in
                    Text(typeEntry.type.name.uppercased()).font(AppFont.pokemonDetail()).padding(.horizontal, 12).padding(.vertical, 6).background(Color.gray.opacity(0.2)).cornerRadius(12)
                }
            }
            HStack(spacing: AppSpacing.large) {
                StatView(name: "Peso", value: "\(Double(viewModel.pokemon.weight) / 10.0) kg")
                StatView(name: "Altura", value: "\(Double(viewModel.pokemon.height) / 10.0) m")
            }
            InfoSectionView(title: "Habilidades", items: viewModel.pokemon.abilities.map { $0.ability.name.capitalized })
            InfoSectionView(title: "Principais Movimentos", items: viewModel.pokemon.moves.prefix(5).map { $0.move.name.capitalized })
        }
    }
}


// MARK: - View Principal
struct PokemonDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: PokemonDetailViewModel
    
    // Construtor simples
    init(pokemon: PokemonDetail) {
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(pokemon: pokemon))
    }
    
    var body: some View {
        ScrollView {
            VStack { // Usamos um VStack para corrigir o problema de alinhamento no ScrollView
                ViewThatFits(in: .horizontal) {
                    PokemonDetailHorizontalLayout(viewModel: viewModel)
                    PokemonDetailVerticalLayout(viewModel: viewModel)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .navigationTitle(viewModel.pokemon.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.toggleFavoriteStatus(context: modelContext)
                }) {
                    Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.title2)
                        .scaleEffect(viewModel.isFavorite ? 1.2 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.5), value: viewModel.isFavorite)
                }
            }
        }
        .onAppear {
            viewModel.checkFavoriteStatus(context: modelContext)
        }
    }
}

// MARK: - Views Auxiliares
struct StatView: View {
    let name: String
    let value: String
    var body: some View {
        VStack {
            Text(name).font(AppFont.pokemonDetail().bold()).foregroundColor(AppColor.textSecondary)
            Text(value).font(AppFont.pokemonBody())
        }
    }
}

struct InfoSectionView: View {
    let title: String
    let items: [String]
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Text(title).font(AppFont.pokemonTitle(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
            ForEach(items, id: \.self) { item in
                Text("• \(item)").font(AppFont.pokemonBody()).foregroundColor(AppColor.textSecondary)
            }
        }
        .padding()
        .background(AppColor.surface)
        .cornerRadius(12)
    }
}
