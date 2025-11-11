import Foundation
import Combine

class GameViewModel: ObservableObject, Hashable {
    let id = UUID()
    @Published var game: Game

    init(game: Game) {
        self.game = game
    }

    func calculateWinner() -> Player? {
        game.players.max(by: { netWorth(for: $0) < netWorth(for: $1) })
    }

    func addProperty(_ property: Property) {
        game.properties.append(property)
    }

    func updateProperty(_ property: Property) {
        if let index = game.properties.firstIndex(where: { $0.id == property.id }) {
            game.properties[index] = property
        }
    }

    func netWorth(for player: Player) -> Int {
        let propertiesValue = game.properties.filter { $0.ownerId == player.id }.reduce(0) { $0 + $1.value }
        return player.cash + propertiesValue
    }

    func owner(for property: Property) -> Player? {
        game.players.first(where: { $0.id == property.ownerId })
    }

    static func == (lhs: GameViewModel, rhs: GameViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
