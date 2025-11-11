import Foundation
import SwiftUI

struct Property: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var originalValue: Double
    var houses: Int
    var costOfHouse: Double
    var hotels: Int
    var costOfHotel: Double
    var isOwned: Bool
    var index: Int
    var color: PropertyColor
    var group: PropertyGroup
    var bonus: Double
    var isMortgaged: Bool
}
