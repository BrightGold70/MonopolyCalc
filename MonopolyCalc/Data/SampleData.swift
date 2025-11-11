import Foundation

struct SampleData {
    static let properties: [Property] = [
        Property(name: "O'Hare Airport", originalValue: 2, houses: 0, costOfHouse: 0, hotels: 0, costOfHotel: 0, isOwned: false, index: 0, color: .black, group: .group1, bonus: 0, isMortgaged: false),
        Property(name: "LAX airport", originalValue: 2, houses: 0, costOfHouse: 0, hotels: 0, costOfHotel: 0, isOwned: false, index: 0, color: .black, group: .group1, bonus: 0, isMortgaged: false),
        Property(name: "JFK airport", originalValue: 2, houses: 0, costOfHouse: 0, hotels: 0, costOfHotel: 0, isOwned: false, index: 0, color: .black, group: .group1, bonus: 0, isMortgaged: false),
        Property(name: "Hartsfield-Jackson Airport", originalValue: 2, houses: 0, costOfHouse: 0, hotels: 0, costOfHotel: 0, isOwned: false, index: 0, color: .black, group: .group1, bonus: 0, isMortgaged: false),
        Property(name: "Cellular Service", originalValue: 1.5, houses: 0, costOfHouse: 0, hotels: 0, costOfHotel: 0, isOwned: false, index: 0, color: .gray, group: .group2, bonus: 0, isMortgaged: false),
        Property(name: "Internet Service", originalValue: 1.5, houses: 0, costOfHouse: 0, hotels: 0, costOfHotel: 0, isOwned: false, index: 0, color: .gray, group: .group2, bonus: 0, isMortgaged: false),
        Property(name: "Jacops Field", originalValue: 0.6, houses: 0, costOfHouse: 0.5, hotels: 0, costOfHotel: 2.5, isOwned: false, index: 0, color: .brown, group: .group3, bonus: 0, isMortgaged: false),
        Property(name: "Texas Field", originalValue: 0.6, houses: 0, costOfHouse: 0.5, hotels: 0, costOfHotel: 2.5, isOwned: false, index: 0, color: .brown, group: .group3, bonus: 0, isMortgaged: false),
        Property(name: "Grand Ole Opry", originalValue: 1, houses: 0, costOfHouse: 0.5, hotels: 0, costOfHotel: 2.5, isOwned: false, index: 0, color: .yellow, group: .group4, bonus: 0, isMortgaged: false),
        Property(name: "Gateway Arch", originalValue: 1, houses: 0, costOfHouse: 0.5, hotels: 0, costOfHotel: 2.5, isOwned: false, index: 0, color: .yellow, group: .group4, bonus: 0, isMortgaged: false),
        Property(name: "Mall of America", originalValue: 1.2, houses: 0, costOfHouse: 1, hotels: 0, costOfHotel: 5, isOwned: false, index: 0, color: .yellow, group: .group4, bonus: 0, isMortgaged: false),
        Property(name: "Red Rocks Park", originalValue: 1.4, houses: 0, costOfHouse: 1, hotels: 0, costOfHotel: 5, isOwned: false, index: 0, color: .purple, group: .group5, bonus: 0, isMortgaged: false),
        Property(name: "Liberty Bell", originalValue: 1.6, houses: 0, costOfHouse: 1, hotels: 0, costOfHotel: 5, isOwned: false, index: 0, color: .purple, group: .group5, bonus: 0, isMortgaged: false),
        Property(name: "South Beach", originalValue: 1.8, houses: 0, costOfHouse: 1, hotels: 0, costOfHotel: 5, isOwned: false, index: 0, color: .purple, group: .group6, bonus: 0, isMortgaged: false),
        Property(name: "Johnson Space Center", originalValue: 1.8, houses: 0, costOfHouse: 1, hotels: 0, costOfHotel: 5, isOwned: false, index: 0, color: .blue, group: .group6, bonus: 0, isMortgaged: false),
        Property(name: "Pioneer Square", originalValue: 2, houses: 0, costOfHouse: 1, hotels: 0, costOfHotel: 5, isOwned: false, index: 0, color: .blue, group: .group6, bonus: 0, isMortgaged: false),
        Property(name: "Mt. Camelback", originalValue: 2.2, houses: 0, costOfHouse: 1.5, hotels: 0, costOfHotel: 7.5, isOwned: false, index: 0, color: .blue, group: .group7, bonus: 0, isMortgaged: false),
        Property(name: "Waikiki Beach", originalValue: 2.2, houses: 0, costOfHouse: 1.5, hotels: 0, costOfHotel: 7.5, isOwned: false, index: 0, color: .blue, group: .group7, bonus: 0, isMortgaged: false),
        Property(name: "Disney World", originalValue: 2.4, houses: 0, costOfHouse: 1.5, hotels: 0, costOfHotel: 7.5, isOwned: false, index: 0, color: .red, group: .group7, bonus: 0, isMortgaged: false),
        Property(name: "French Quarter", originalValue: 2.6, houses: 0, costOfHouse: 1.5, hotels: 0, costOfHotel: 7.5, isOwned: false, index: 0, color: .red, group: .group8, bonus: 0, isMortgaged: false),
        Property(name: "Hollywood", originalValue: 2.6, houses: 0, costOfHouse: 1.5, hotels: 0, costOfHotel: 7.5, isOwned: false, index: 0, color: .red, group: .group8, bonus: 0, isMortgaged: false),
        Property(name: "Goldengate Bridge", originalValue: 2.8, houses: 0, costOfHouse: 1.5, hotels: 0, costOfHotel: 7.5, isOwned: false, index: 0, color: .blue, group: .group8, bonus: 0, isMortgaged: false),
        Property(name: "Casino Street", originalValue: 3, houses: 0, costOfHouse: 2, hotels: 0, costOfHotel: 10, isOwned: false, index: 0, color: .blue, group: .group9, bonus: 0, isMortgaged: false),
        Property(name: "Wrigley Field", originalValue: 3, houses: 0, costOfHouse: 2, hotels: 0, costOfHotel: 10, isOwned: false, index: 0, color: .blue, group: .group9, bonus: 0, isMortgaged: false),
        Property(name: "White House", originalValue: 3.2, houses: 0, costOfHouse: 2, hotels: 0, costOfHotel: 10, isOwned: false, index: 0, color: .blue, group: .group9, bonus: 0, isMortgaged: false),
        Property(name: "Fenway Park", originalValue: 3.5, houses: 0, costOfHouse: 2, hotels: 0, costOfHotel: 10, isOwned: false, index: 0, color: .blue, group: .group10, bonus: 0, isMortgaged: false),
        Property(name: "Times Square", originalValue: 4, houses: 0, costOfHouse: 2, hotels: 0, costOfHotel: 10, isOwned: false, index: 0, color: .blue, group: .group10, bonus: 0, isMortgaged: false)
    ]
}
