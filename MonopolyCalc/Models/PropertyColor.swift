import Foundation
import SwiftData
import SwiftUI

@Model
final class PropertyColor {
    @Attribute(.unique) var id: String
    var name: String

    init(name: String) {
        self.id = name
        self.name = name
    }

    var color: Color {
        switch name {
            case "brown": return Color(hex: "#955436")
            case "lightBlue": return Color(hex: "#aae0fa")
            case "pink": return Color(hex: "#d93a96")
            case "orange": return Color(hex: "#f7941d")
            case "red": return Color(hex: "#ed1c24")
            case "yellow": return Color(hex: "#fef200")
            case "green": return Color(hex: "#1fb25a")
            case "blue": return Color(hex: "#0072bb")
            case "black": return .black
            case "gray": return .gray
            default: return .primary
        }
    }
}
