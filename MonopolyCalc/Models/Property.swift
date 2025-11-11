import Foundation
import SwiftUI

enum PropertyColor: String, CaseIterable, Identifiable {
    case brown, lightBlue, pink, orange, red, yellow, green, darkBlue, railroad, utility

    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .brown: return Color(red: 0.58, green: 0.33, blue: 0.21)
        case .lightBlue: return Color(red: 0.67, green: 0.88, blue: 0.98)
        case .pink: return Color(red: 0.8, green: 0.0, blue: 0.5)
        case .orange: return Color(red: 0.99, green: 0.6, blue: 0.0)
        case .red: return Color.red
        case .yellow: return Color.yellow
        case .green: return Color.green
        case .darkBlue: return Color.blue
        case .railroad: return Color.gray
        case .utility: return Color.purple
        }
    }
}

struct Property: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var value: Int
    var color: PropertyColor
    var isMortgaged: Bool = false
    var houses: Int = 0
    var hotels: Int = 0
    var ownerId: UUID? = nil
    var rent: Int
    var houseCost: Int
    var hotelCost: Int
    var isMonopoly: Bool = false
}
