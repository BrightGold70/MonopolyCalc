import SwiftUI
import SwiftData

struct PropertyDetailView: View {
    @State var property: Property
    @ObservedObject var viewModel: GameViewModel
    @State private var showingEditSheet = false

    var body: some View {
        Form {
            Section(header: Text("Property Details")) {
                Text("Name: \(property.name)")
                Text("Value: $\(property.originalValue, specifier: "%.2f")")
                Text("Owner: \(viewModel.getOwner(of: property)?.name ?? "Unowned")")
            }

            Section(header: Text("Development")) {
                Text("Houses: \(property.houses)")
                Text("Hotels: \(property.hotels)")
                Text("House Cost: $\(property.costOfHouse, specifier: "%.2f")")
                Text("Hotel Cost: $\(property.costOfHotel, specifier: "%.2f")")
            }

            Section(header: Text("Status")) {
                Text("Mortgaged: \(property.isMortgaged ? "Yes" : "No")")
            }
        }
        .navigationTitle(property.name)
        .navigationBarItems(trailing: Button("Edit") {
            showingEditSheet = true
        })
        .sheet(isPresented: $showingEditSheet) {
            EditPropertyStateView(viewModel: viewModel, property: $property)
        }
    }
}

struct PropertyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let modelContainer = try! ModelContainer(for: GameRecord.self, PlayerProfile.self, PropertySet.self)
        let game = Game.sampleGame
        let viewModel = GameViewModel(game: game, modelContext: modelContainer.mainContext)
        PropertyDetailView(property: game.properties[0], viewModel: viewModel)
            .modelContainer(modelContainer)
    }
}
