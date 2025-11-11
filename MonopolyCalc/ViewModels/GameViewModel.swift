import Foundation
import SwiftData
import SwiftUI

@MainActor
class GameViewModel: ObservableObject, Hashable {
    let id = UUID()
    @Published var game: Game
    private var modelContext: ModelContext

    init(game: Game, modelContext: ModelContext) {
        self.game = game
        self.modelContext = modelContext
    }

    var allPropertiesWithOwnership: [Property] {
        var properties = game.properties
        for (index, property) in properties.enumerated() {
            let isOwnedByanyPlayer = game.players.contains { player in
                player.properties.contains { $0.id == property.id }
            }
            properties[index].isOwned = isOwnedByanyPlayer
        }
        return properties
    }

    func calculateNetWorth(for player: Player) -> Double {
        var netWorth = player.money

        for property in player.properties {
            var propertyValue = property.originalValue

            // Double value for monopolies
            if hasMonopoly(for: property.group, ownedBy: player) {
                propertyValue *= 2
            }

            // 10% value for mortgaged properties
            if property.isMortged {
                propertyValue *= 0.1
            }

            netWorth += propertyValue
            netWorth += Double(property.houses) * property.costOfHouse
            netWorth += Double(property.hotels) * property.costOfHotel
        }

        return netWorth
    }

    private func hasMonopoly(for group: PropertyGroup?, ownedBy player: Player) -> Bool {
        guard let group = group else { return false }

        let allPropertiesInGroup = game.properties.filter { $0.group == group }
        let playerPropertiesInGroup = player.properties.filter { $0.group == group }

        return allPropertiesInGroup.count == playerPropertiesInGroup.count
    }

    func calculateWinner() -> Player? {
        game.players.max(by: { calculateNetWorth(for: $0) < calculateNetWorth(for: $1) })
    }

    func addProperty(_ property: Property) {
        game.properties.append(property)
    }

    func updateProperty(_ property: Property) {
        if let index = game.properties.firstIndex(where: { $0.id == property.id }) {
            game.properties[index] = property
        }
    }

    func updatePropertyOwner(for property: Property, newOwner: Player?) {
        // Remove property from all players first
        for player in game.players {
            player.properties.removeAll { $0.id == property.id }
        }

        // Add to the new owner if one is selected
        if let newOwner = newOwner {
            if let playerIndex = game.players.firstIndex(where: { $0.id == newOwner.id }) {
                game.players[playerIndex].properties.append(property)
            }
        }

        updateProperty(property)
    }

    func getOwner(of property: Property) -> Player? {
        return game.players.first(where: { $0.properties.contains(where: { $0.id == property.id }) })
    }

    func saveGameRecord() {
        let winner = calculateWinner()
        let gameRecord = GameRecord(date: Date(), players: game.players, winner: winner)
        modelContext.insert(gameRecord)
    }

    static func == (lhs: GameViewModel, rhs: GameViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
