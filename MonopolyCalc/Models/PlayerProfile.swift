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
        PlayerProfile(name: "Alice", icon: "hare.fill", gamesPlayed: 3),
        PlayerProfile(name: "Bob", icon: "car.fill", gamesPlayed: 10),
        PlayerProfile(name: "Charlie", icon: "dog.fill", gamesPlayed: 5),
        PlayerProfile(name: "David", icon: "airplane", gamesPlayed: 1),
        PlayerProfile(name: "Eva", icon: "gamecontroller.fill", gamesPlayed: 0),
        PlayerProfile(name: "Frank", icon: "joystick.fill", gamesPlayed: 5)
    ]
}
