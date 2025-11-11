import Foundation
import SwiftData

@Model
final class GameRecord {
    @Attribute(.unique) var id: UUID
    var date: Date
    @Relationship(deleteRule: .cascade) var players: [Player]
    var winner: Player?

    init(id: UUID = UUID(), date: Date, players: [Player], winner: Player?) {
        self.id = id
        self.date = date
        self.players = players
        self.winner = winner
    }
}
