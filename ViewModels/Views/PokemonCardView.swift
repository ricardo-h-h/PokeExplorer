import SwiftUI

struct PokemonCardView: View {
    let id: Int
    let name: String
    let imageURL: String?
    
    @State private var urlForImage: URL?
    
    // Construtor simples
    init(id: Int, name: String, imageURL: String?) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: urlForImage) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
            } placeholder: {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
            
            Text(name.capitalized)
                .font(AppFont.pokemonBody())
                .foregroundColor(AppColor.textPrimary)
            
            Text(String(format: "#%03d", id))
                .font(AppFont.pokemonDetail())
                .foregroundColor(AppColor.textSecondary)
        }
        .padding(AppSpacing.small)
        .background(AppColor.surface)
        .cornerRadius(12)
        .shadow(radius: 4)
        .onAppear {
            updateURL()
        }
        .onChange(of: imageURL) {
            updateURL()
        }
    }
    
    private func updateURL() {
        if let urlString = imageURL, !urlString.isEmpty {
            self.urlForImage = URL(string: urlString)
        }
    }
}
