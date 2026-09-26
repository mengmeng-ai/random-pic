import SwiftUI

struct AppTheme {
    static let primary = Color(hex: "DA7756")
    static let primaryLight = Color(hex: "E8A991")
    static let primaryDark = Color(hex: "C4654A")
    static let background = Color(hex: "FAF9F6")
    static let backgroundDark = Color(hex: "2B2926")
    static let surface = Color.white
    static let surfaceDark = Color(hex: "353330")
    static let textPrimary = Color(hex: "2D2B28")
    static let textSecondary = Color(hex: "7C7B78")
    static let textPrimaryDark = Color(hex: "EDEDEC")
    static let textSecondaryDark = Color(hex: "A8A6A2")
    static let border = Color(hex: "E8E6E1")
    static let borderDark = Color(hex: "4A4845")

    static let messageSent = Color(hex: "DA7756")
    static let messageReceived = Color(hex: "F0EFEB")
    static let messageReceivedDark = Color(hex: "3D3B38")

    static let sidebarBg = Color(hex: "F0EFEB")
    static let sidebarBgDark = Color(hex: "2F2D2A")

    static let cornerRadius: CGFloat = 16
    static let smallCornerRadius: CGFloat = 8
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
