import Foundation

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var avatar: String
    var cash: Int
    var properties: [Property]
    var netWorth: Int {
        cash + properties.reduce(0) { $0 + $1.value }
    }
}
