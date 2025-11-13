import Foundation
import SwiftData
import SwiftUI

struct PlayerRanking: Identifiable {
    let id: UUID
    let name: String
    let netWorth: Double
    let cash: Double
    let propertyValue: Double
    let buildingValue: Double
}

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

    func calculateScoreBreakdown(for player: Player) -> (cash: Double, propertyValue: Double, buildingValue: Double, netWorth: Double) {
        let cash = player.money
        var propertyValue: Double = 0
        var buildingValue: Double = 0

        for property in player.properties {
            var currentPropertyValue = property.originalValue

            if hasMonopoly(for: property.group, ownedBy: player) {
                currentPropertyValue *= 2
            }

            if property.isMortgaged {
                currentPropertyValue *= 0.1
            }

            propertyValue += currentPropertyValue
            buildingValue += Double(property.houses) * property.costOfHouse
            buildingValue += Double(property.hotels) * property.costOfHotel
        }

        let netWorth = cash + propertyValue + buildingValue
        return (cash, propertyValue, buildingValue, netWorth)
    }

    func getPlayerRankings() -> [PlayerRanking] {
        return game.players
            .map { player in
                let breakdown = calculateScoreBreakdown(for: player)
                return PlayerRanking(
                    id: player.id,
                    name: player.name,
                    netWorth: breakdown.netWorth,
                    cash: breakdown.cash,
                    propertyValue: breakdown.propertyValue,
                    buildingValue: breakdown.buildingValue
                )
            }
            .sorted { $0.netWorth > $1.netWorth }
    }

    private func hasMonopoly(for group: PropertyGroup?, ownedBy player: Player) -> Bool {
        guard let group = group else { return false }

        let allPropertiesInGroup = game.properties.filter { $0.group == group }
        let playerPropertiesInGroup = player.properties.filter { $0.group == group }

        return !allPropertiesInGroup.isEmpty && allPropertiesInGroup.count == playerPropertiesInGroup.count
    }

    func calculateWinner() -> Player? {
        game.players.max(by: { calculateScoreBreakdown(for: $0).netWorth < calculateScoreBreakdown(for: $1).netWorth })
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
        for player in game.players {
            player.properties.removeAll { $0.id == property.id }
        }

        if let newOwner = newOwner, let playerIndex = game.players.firstIndex(where: { $0.id == newOwner.id }) {
            game.players[playerIndex].properties.append(property)
        }

        updateProperty(property)
    }

    func getOwner(of property: Property) -> Player? {
        return game.players.first(where: { $0.properties.contains(where: { $0.id == property.id }) })
    }

    func saveGameRecord() {
        let scores = game.players.map { player -> PlayerScore in
            let netWorth = calculateScoreBreakdown(for: player).netWorth
            return PlayerScore(playerName: player.name, netWorth: netWorth)
        }

        let gameRecord = GameRecord(date: Date(), scores: scores)
        modelContext.insert(gameRecord)
    }

    static func == (lhs: GameViewModel, rhs: GameViewModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
