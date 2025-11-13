import Foundation
import SwiftData

@Model
final class SavedProperty {
    var name: String
    var isOwned: Bool
    var ownerName: String?
    var houses: Int
    var hotels: Int
    var isMortgaged: Bool

    // Duplicating these from the main Property model for reconstruction
    var originalValue: Double
    var costOfHouse: Double
    var costOfHotel: Double
    var index: Int
    @Relationship var color: PropertyColor?
    @Relationship var group: PropertyGroup?
    var bonus: Int

    init(name: String, isOwned: Bool, ownerName: String?, houses: Int, hotels: Int, isMortgaged: Bool, originalValue: Double, costOfHouse: Double, costOfHotel: Double, index: Int, color: PropertyColor?, group: PropertyGroup?, bonus: Int) {
        self.name = name
        self.isOwned = isOwned
        self.ownerName = ownerName
        self.houses = houses
        self.hotels = hotels
        self.isMortgaged = isMortgaged
        self.originalValue = originalValue
        self.costOfHouse = costOfHouse
        self.costOfHotel = costOfHotel
        self.index = index
        self.color = color
        self.group = group
        self.bonus = bonus
    }
}
