import Foundation

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var avatar: String
    var cash: Int

    var netWorth: Int {
        // This will be recalculated in the view model
        cash
    }
}
