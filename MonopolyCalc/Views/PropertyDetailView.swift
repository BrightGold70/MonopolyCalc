import SwiftUI

struct PropertyDetailView: View {
    @ObservedObject var viewModel: GameViewModel
    let property: Property
    @State private var showingEditSheet = false

    var body: some View {
        Form {
            Section(header: Text("Property Details")) {
                Text("Name: \(property.name)")
                Text("Value: $\(property.value)")
                Text("Rent: $\(property.rent)")
                Text("Owner: \(viewModel.owner(for: property)?.name ?? "Unowned")")
            }

            Section(header: Text("Development")) {
                Text("Houses: \(property.houses)")
                Text("Hotels: \(property.hotels)")
                Text("House Cost: $\(property.houseCost)")
                Text("Hotel Cost: $\(property.hotelCost)")
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
        PropertyDetailView(viewModel: GameViewModel(game: Game.sampleGame), property: Game.sampleGame.properties[0])
    }
}
