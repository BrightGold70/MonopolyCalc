import Foundation
import SwiftData

@Model
final class GameRecord {
    @Attribute(.unique) var id: UUID
    var date: Date
    @Relationship(deleteRule: .cascade) var scores: [PlayerScore]

    init(id: UUID = UUID(), date: Date, scores: [PlayerScore]) {
        self.id = id
        self.date = date
        self.scores = scores
    }

    var winner: PlayerScore? {
        scores.max(by: { $0.netWorth < $1.netWorth })
    }

    var playerNames: String {
        scores.map { $0.playerName }.joined(separator: ", ")
    }
}
