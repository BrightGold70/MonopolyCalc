import Foundation
import SwiftData

@Model
final class GameSetupTemplate {
    @Attribute(.unique) var id: UUID
    var name: String
    var startingCash: Double
    @Relationship(deleteRule: .nullify) var propertySet: PropertySet?
    @Relationship(deleteRule: .nullify) var players: [PlayerProfile]

    init(id: UUID = UUID(), name: String, startingCash: Double, propertySet: PropertySet?, players: [PlayerProfile]) {
        self.id = id
        self.name = name
        self.startingCash = startingCash
        self.propertySet = propertySet
        self.players = players
    }
}
