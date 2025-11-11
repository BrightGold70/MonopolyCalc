import Foundation

class ScoreViewModel: ObservableObject {
    @Published var cash: String = ""
    @Published var properties: String = ""
    @Published var houses: Int = 0
    @Published var hotels: Int = 0
    @Published var railroads: Int = 0
    @Published var utilities: Int = 0

    var totalScore: Int {
        let cashValue = Int(cash) ?? 0
        let propertiesValue = Int(properties) ?? 0

        // Standard Monopoly values
        let housesValue = houses * 100
        let hotelsValue = hotels * 500
        let railroadsValue = railroads * 200
        let utilitiesValue = utilities * 150

        return cashValue + propertiesValue + housesValue + hotelsValue + railroadsValue + utilitiesValue
    }
}
