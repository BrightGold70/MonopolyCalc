import Foundation

enum PropertyColor: String {
    case brown, lightBlue, pink, orange, red, yellow, green, darkBlue
}

struct Property: Identifiable {
    let id = UUID()
    var name: String
    var value: Int
    var color: PropertyColor
    var isMortgaged: Bool = false
    var houses: Int = 0
    var hotels: Int = 0
}
