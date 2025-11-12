import Foundation
import SwiftData
import SwiftUI

@MainActor
class PlayerManagementViewModel: ObservableObject {
    @Published var players: [PlayerProfile] = []

    private var modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchPlayers()
    }

    func fetchPlayers() {
        do {
            let descriptor = FetchDescriptor<PlayerProfile>(sortBy: [SortDescriptor(\.name)])
            players = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch players: \(error)")
        }
    }

    func addPlayer(name: String, icon: String) {
        let newPlayer = PlayerProfile(name: name, icon: icon, gamesPlayed: 0)
        modelContext.insert(newPlayer)
        fetchPlayers()
    }

    func updatePlayer(_ player: PlayerProfile, name: String, icon: String) {
        player.name = name
        player.icon = icon
        fetchPlayers()
    }

    func deletePlayer(_ player: PlayerProfile) {
        modelContext.delete(player)
        fetchPlayers()
    }
}
