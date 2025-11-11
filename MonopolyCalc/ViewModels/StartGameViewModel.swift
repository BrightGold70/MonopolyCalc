import Foundation
import SwiftData
import SwiftUI

@MainActor
class StartGameViewModel: ObservableObject {
    @Published var availablePlayers: [PlayerProfile] = []
    @Published var selectedPlayers: [PlayerProfile] = []
    @Published var startingCash: Double = 1500
    @Published var propertySets: [PropertySet] = []
    @Published var selectedPropertySet: PropertySet?

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
        seedInitialData()
    }

    func fetchData() {
        do {
            let playerDescriptor = FetchDescriptor<PlayerProfile>(sortBy: [SortDescriptor(\.name)])
            availablePlayers = try modelContext.fetch(playerDescriptor)

            let setDescriptor = FetchDescriptor<PropertySet>(sortBy: [SortDescriptor(\.name)])
            propertySets = try modelContext.fetch(setDescriptor)

            if selectedPropertySet == nil {
                selectedPropertySet = propertySets.first
            }

        } catch {
            print("Failed to fetch data: \(error)")
        }
    }

    private func seedInitialData() {
        if propertySets.isEmpty {
            let defaultSet = PropertySet.defaultSet
            modelContext.insert(defaultSet)
            // Manually insert all properties from the default set
            for property in defaultSet.properties {
                modelContext.insert(property)
                if let color = property.color {
                    modelContext.insert(color)
                }
                if let group = property.group {
                    modelContext.insert(group)
                }
            }
            fetchData()
        }

        if availablePlayers.isEmpty {
            for player in PlayerProfile.samplePlayers {
                modelContext.insert(player)
            }
            fetchData() // re-fetch to get the sorted list
        }
    }

    func selectPlayer(_ player: PlayerProfile) {
        if !selectedPlayers.contains(where: { $0.id == player.id }) {
            selectedPlayers.append(player)
        }
    }

    func deselectPlayer(_ player: PlayerProfile) {
        selectedPlayers.removeAll { $0.id == player.id }
    }

    func createNewPlayer(name: String, icon: String) {
        let newPlayer = PlayerProfile(name: name, icon: icon, gamesPlayed: 0)
        modelContext.insert(newPlayer)
        fetchData() // Refresh the player list
    }

    func createGame() -> Game? {
        guard let propertySet = selectedPropertySet else { return nil }

        let players = selectedPlayers.map {
            Player(name: $0.name, money: startingCash, properties: [])
        }

        let gameProperties = propertySet.properties.map { p in
            Property(
                name: p.name,
                originalValue: p.originalValue,
                houses: p.houses,
                costOfHouse: p.costOfHouse,
                hotels: p.hotels,
                costOfHotel: p.costOfHotel,
                isOwned: false,
                index: p.index,
                color: p.color ?? PropertyColor(name: "gray"),
                group: p.group ?? PropertyGroup(name: "group1"),
                bonus: p.bonus,
                isMortgaged: false
            )
        }

        return Game(players: players, properties: gameProperties)
    }
}
