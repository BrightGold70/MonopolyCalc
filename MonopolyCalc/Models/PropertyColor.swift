import SwiftUI

enum PropertyColor: String, CaseIterable, Identifiable {
    case black, gray, brown, yellow, purple, blue, red

    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .black: return .black
        case .gray: return .gray
        case .brown: return Color(red: 0.58, green: 0.33, blue: 0.21)
        case .yellow: return .yellow
        case .purple: return .purple
        case .blue: return .blue
        case .red: return .red
        }
    }
}
