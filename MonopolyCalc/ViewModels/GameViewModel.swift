import Foundation
import Combine

class GameViewModel: ObservableObject, Hashable {
    let id = UUID()
    @Published var game: Game

    init(game: Game) {
        self.game = game
    }

    var allPropertiesWithOwnership: [Property] {
        var properties = game.properties
        for (index, property) in properties.enumerated() {
            let isOwned = game.players.contains(where: { $0.properties.contains(where: { $0.id == property.id }) })
            properties[index].isOwned = isOwned
        }
        return properties
    }

    func calculateWinner() -> Player? {
        game.players.max(by: { $0.netWorth < $1.netWorth })
    }

    func addProperty(_ property: Property) {
        game.properties.append(property)
    }

    func updateProperty(_ property: Property) {
        if let index = game.properties.firstIndex(where: { $0.id == property.id }) {
            game.properties[index] = property
        }
    }

    static func == (lhs: GameViewModel, rhs: GameViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
