import Foundation
import SwiftData
import SwiftUI
import Combine

@MainActor
class StartGameViewModel: ObservableObject {
    @Published var availablePlayers: [PlayerProfile] = []
    @Published var selectedPlayers: [PlayerProfile] = [] {
        didSet {
            checkForCustomSetup()
        }
    }
    @Published var startingCash: Double = 1500 {
        didSet {
            checkForCustomSetup()
        }
    }
    @Published var propertySets: [PropertySet] = []
    @Published var selectedPropertySet: PropertySet? {
        didSet {
            checkForCustomSetup()
        }
    }

    @Published var templates: [GameSetupTemplate] = []
    @Published var selectedTemplateID: UUID?

    private var modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()

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

            let templateDescriptor = FetchDescriptor<GameSetupTemplate>(sortBy: [SortDescriptor(\.name)])
            templates = try modelContext.fetch(templateDescriptor)

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
            for property in defaultSet.properties {
                modelContext.insert(property)
                if let color = property.color { modelContext.insert(color) }
                if let group = property.group { modelContext.insert(group) }
            }
        }

        if availablePlayers.isEmpty {
            PlayerProfile.samplePlayers.forEach { modelContext.insert($0) }
        }

        if templates.isEmpty {
            let familyGame = GameSetupTemplate(name: "Family Game Night", startingCash: 1500, propertySet: propertySets.first, players: Array(availablePlayers.prefix(4)))
            modelContext.insert(familyGame)
        }

        fetchData()
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
        fetchData()
    }

    func saveTemplate(name: String) {
        let newTemplate = GameSetupTemplate(name: name, startingCash: startingCash, propertySet: selectedPropertySet, players: selectedPlayers)
        modelContext.insert(newTemplate)
        fetchData()
        selectedTemplateID = newTemplate.id
    }

    func loadTemplate(id: UUID?) {
        guard let id = id, let template = templates.first(where: { $0.id == id }) else {
            selectedTemplateID = nil
            return
        }

        self.startingCash = template.startingCash
        self.selectedPropertySet = template.propertySet
        self.selectedPlayers = template.players
        self.selectedTemplateID = id
    }

    private func checkForCustomSetup() {
        guard let templateID = selectedTemplateID,
              let template = templates.first(where: { $0.id == templateID }) else {
            return
        }

        let isDifferent = startingCash != template.startingCash ||
                          selectedPropertySet?.id != template.propertySet?.id ||
                          Set(selectedPlayers.map { $0.id }) != Set(template.players.map { $0.id })

        if isDifferent {
            self.selectedTemplateID = nil
        }
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
                houses: p.houses, costOfHouse: p.costOfHouse,
                hotels: p.hotels, costOfHotel: p.costOfHotel,
                isOwned: false, index: p.index,
                color: p.color ?? PropertyColor(name: "gray"),
                group: p.group ?? PropertyGroup(name: "group1"),
                bonus: p.bonus, isMortgaged: false
            )
        }

        return Game(players: players, properties: gameProperties)
    }
}
