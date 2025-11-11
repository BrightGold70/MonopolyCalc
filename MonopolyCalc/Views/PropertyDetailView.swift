import SwiftUI

struct PropertyDetailView: View {
    let property: Property
    @ObservedObject var viewModel: GameViewModel
    @State private var showingEditSheet = false

    var body: some View {
        Form {
            Section(header: Text("Property Details")) {
                Text("Name: \(property.name)")
                Text("Value: $\(property.originalValue, specifier: "%.2f")")
                Text("Owner: \(property.isOwned ? "Owned" : "Unowned")")
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
            ManagePropertyView(viewModel: viewModel, propertyToEdit: property)
        }
    }
}

struct PropertyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyDetailView(property: Game.sampleGame.properties[0], viewModel: GameViewModel(game: Game.sampleGame))
    }
}
