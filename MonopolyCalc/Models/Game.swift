import Foundation

class Game: ObservableObject {
    @Published var players: [Player]
    @Published var selectedPlayerIndex: Int = 0

    init(players: [Player]) {
        self.players = players
    }
}

extension Game {
    static var samplePlayers: [Player] {
        [
            Player(name: "Alex", avatar: "player1", cash: 500, properties: [
                Property(name: "Boardwalk", value: 2400, color: .darkBlue, hotels: 1),
                Property(name: "Pennsylvania Avenue", value: 920, color: .green, houses: 3),
                Property(name: "Connecticut Avenue", value: 60, color: .lightBlue, isMortgaged: true)
            ]),
            Player(name: "Ben", avatar: "player2", cash: 1800, properties: []),
            Player(name: "Casey", avatar: "player3", cash: 2200, properties: []),
            Player(name: "Dana", avatar: "player4", cash: 1950, properties: [])
        ]
    }
}
