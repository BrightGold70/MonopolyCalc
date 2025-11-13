import Foundation
import SwiftData

@Model
final class Property: Identifiable, Hashable {
    @Attribute(.unique) let id: UUID
    var name: String
    var originalValue: Double
    var houses: Int
    var costOfHouse: Double
    var hotels: Int
    var costOfHotel: Double
    var isOwned: Bool
    var index: Int
    @Relationship(deleteRule: .nullify) var color: PropertyColor?
    @Relationship(deleteRule: .nullify) var group: PropertyGroup?
    var bonus: Int
    var isMortgaged: Bool

    @Transient var owner: Player?

    init(id: UUID = UUID(), name: String, originalValue: Double, houses: Int, costOfHouse: Double, hotels: Int, costOfHotel: Double, isOwned: Bool, index: Int, color: PropertyColor, group: PropertyGroup, bonus: Int, isMortgaged: Bool, owner: Player? = nil) {
        self.id = id
        self.name = name
        self.originalValue = originalValue
        self.houses = houses
        self.costOfHouse = costOfHouse
        self.hotels = hotels
        self.costOfHotel = costOfHotel
        self.isOwned = isOwned
        self.index = index
        self.color = color
        self.group = group
        self.bonus = bonus
        self.isMortgaged = isMortgaged
        self.owner = owner
    }

    static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
