import Foundation

extension Game {
    static var sampleGame: Game {
        Game(players: [
            Player(name: "Player 1", avatar: "player1", cash: 1500, properties: [])
        ], properties: [
            Property(name: "Mediterranean Avenue", value: 60, color: .brown, rent: 2, houseCost: 50, hotelCost: 250),
            Property(name: "Baltic Avenue", value: 60, color: .brown, rent: 4, houseCost: 50, hotelCost: 450),
            Property(name: "Oriental Avenue", value: 100, color: .lightBlue, rent: 6, houseCost: 50, hotelCost: 550, isMonopoly: true),
            Property(name: "Vermont Avenue", value: 100, color: .lightBlue, rent: 6, houseCost: 50, hotelCost: 550),
            Property(name: "Connecticut Avenue", value: 120, color: .lightBlue, rent: 8, houseCost: 50, hotelCost: 600),
        ])
    }
}
