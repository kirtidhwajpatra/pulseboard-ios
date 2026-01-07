import SwiftUI

// MARK: - Design System

struct DesignSystem {
    struct Colors {
        // Main Backgrounds
        static let background = Color(hex: "0D0D0D") // Almost black
        static let cardSurface = Color(hex: "1C1C1E")
        static let cardSurfaceLighter = Color(hex: "2C2C2E")
        
        // Accents (Apps Decoded Palette)
        static let peach = Color(hex: "FF9F89")
        static let lavender = Color(hex: "BCA6FF")
        static let cyan = Color(hex: "00C2D1")
        static let softBlue = Color(hex: "A8D1E7")
        static let offWhite = Color(hex: "F2F2F7")
        
        // Text
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.6)
        static let textDark = Color(hex: "1A1A1A")
    }
}

// MARK: - Color Hex Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
