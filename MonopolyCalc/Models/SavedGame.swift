import Foundation
import SwiftData

@Model
final class SavedGame {
    @Attribute(.unique) var id: UUID
    var date: Date
    @Relationship(deleteRule: .cascade) var players: [SavedPlayer]
    @Relationship(deleteRule: .cascade) var properties: [SavedProperty]

    init(id: UUID = UUID(), date: Date, players: [SavedPlayer], properties: [SavedProperty]) {
        self.id = id
        self.date = date
        self.players = players
        self.properties = properties
    }
}
