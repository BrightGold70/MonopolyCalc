import Foundation
import SwiftData

@Model
final class PlayerProfile {
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String
    var gamesPlayed: Int

    init(id: UUID = UUID(), name: String, icon: String, gamesPlayed: Int) {
        self.id = id
        self.name = name
        self.icon = icon
        self.gamesPlayed = gamesPlayed
    }
}

extension PlayerProfile {
    static let samplePlayers = [
        PlayerProfile(name: "Alice", icon: "cruelty_free", gamesPlayed: 3),
        PlayerProfile(name: "Bob", icon: "directions_car", gamesPlayed: 10),
        PlayerProfile(name: "Charlie", icon: "pets", gamesPlayed: 5),
        PlayerProfile(name: "David", icon: "rocket_launch", gamesPlayed: 1),
        PlayerProfile(name: "Eva", icon: "stadia_controller", gamesPlayed: 0),
        PlayerProfile(name: "Frank", icon: "joystick", gamesPlayed: 5)
    ]
}
