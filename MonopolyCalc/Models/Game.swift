import Foundation

struct Game {
    var players: [Player]
    var properties: [Property]

    static var sampleGame: Game {
        Game(players: [
            Player(name: "Player 1", money: 1500.0, properties: []),
            Player(name: "Player 2", money: 1500.0, properties: []),
            Player(name: "Player 3", money: 1500.0, properties: [])
        ], properties: SampleData.properties)
    }
}
