import Foundation
import SwiftData

@Model
final class PlayerScore {
    var playerName: String
    var netWorth: Double

    init(playerName: String, netWorth: Double) {
        self.playerName = playerName
        self.netWorth = netWorth
    }
}
