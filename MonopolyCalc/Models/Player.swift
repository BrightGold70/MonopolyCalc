import Foundation
import SwiftData

@Model
final class Player: Identifiable {
    @Attribute(.unique) let id: UUID
    var name: String
    var money: Double
    @Relationship(deleteRule: .nullify) var properties: [Property] = []

    init(id: UUID = UUID(), name: String, money: Double, properties: [Property]) {
        self.id = id
        self.name = name
        self.money = money
        self.properties = properties
    }

    var netWorth: Double {
        properties.reduce(money) { $0 + $1.originalValue }
    }
}
