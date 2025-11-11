import Foundation
import SwiftData

@Model
final class Game {
    var players: [Player]
    var properties: [Property]

    init(players: [Player], properties: [Property]) {
        self.players = players
        self.properties = properties
    }
}

extension Game {
    static var sampleGame: Game {
        Game(players: [
            Player(name: "Player 1", money: 1500.0, properties: []),
            Player(name: "Player 2", money: 1500.0, properties: []),
            Player(name: "Player 3", money: 1500.0, properties: [])
        ], properties: SampleData.properties)
    }
}
