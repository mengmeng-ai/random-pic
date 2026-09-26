import SwiftUI

struct AppTheme {
    static let primary = Color(hex: "7C5CFC")
    static let primaryLight = Color(hex: "B8A9FF")
    static let primaryDark = Color(hex: "5A3ED9")
    static let background = Color(hex: "F9F8FF")
    static let backgroundDark = Color(hex: "1A1625")
    static let surface = Color.white
    static let surfaceDark = Color(hex: "241F31")
    static let textPrimary = Color(hex: "1A1625")
    static let textSecondary = Color(hex: "6E6885")
    static let textPrimaryDark = Color(hex: "F0EDFF")
    static let textSecondaryDark = Color(hex: "9B95B0")
    static let border = Color(hex: "E8E5F0")
    static let borderDark = Color(hex: "3D3552")

    static let messageSent = Color(hex: "7C5CFC")
    static let messageReceived = Color(hex: "F0EDFF")
    static let messageReceivedDark = Color(hex: "2D2740")

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
