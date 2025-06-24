import SwiftUI

// Enum para garantir que só usaremos as cores pré-definidas.
enum AppColor {
    static let primary = Color("Primary")         // Cor principal (ex: um vermelho Pokémon)
    static let background = Color("Background")   // Cor de fundo das telas
    static let surface = Color("Surface")         // Cor de fundo de cards e elementos
    static let textPrimary = Color("TextPrimary") // Cor principal de texto
    static let textSecondary = Color("TextSecondary") // Cor secundária de texto
}

// Enum para tipografia, garantindo consistência nos textos.
enum AppFont {
    static func pokemonTitle(size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }

    static func pokemonBody(size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
    
    static func pokemonDetail(size: CGFloat = 14) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }
}

// Struct para espaçamentos padronizados.
struct AppSpacing {
    static let xsmall: CGFloat = 4
    static let small: CGFloat = 8
    static let medium: CGFloat = 16
    static let large: CGFloat = 24
    static let xlarge: CGFloat = 32
}
