import Foundation
import SwiftData

@Model
final class SavedPlayer {
    var name: String
    var money: Double
    var propertyNames: [String]

    init(name: String, money: Double, propertyNames: [String]) {
        self.name = name
        self.money = money
        self.propertyNames = propertyNames
    }
}
