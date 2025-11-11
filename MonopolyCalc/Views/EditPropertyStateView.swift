import SwiftUI
import SwiftData

struct EditPropertyStateView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var property: Property
    @Environment(\.presentationMode) var presentationMode

    @State private var ownerId: UUID?
    @State private var houses: Int
    @State private var hotels: Int
    @State private var isMortgaged: Bool

    init(viewModel: GameViewModel, property: Binding<Property>) {
        self.viewModel = viewModel
        self._property = property

        _houses = State(initialValue: property.wrappedValue.houses)
        _hotels = State(initialValue: property.wrappedValue.hotels)
        _isMortgaged = State(initialValue: property.wrappedValue.isMortgaged)

        // Find the owner of the property
        if let owner = viewModel.game.players.first(where: { $0.properties.contains(where: { $0.id == property.wrappedValue.id }) }) {
            _ownerId = State(initialValue: owner.id)
        } else {
            _ownerId = State(initialValue: nil)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Ownership")) {
                    Picker("Owner", selection: $ownerId) {
                        Text("Unowned").tag(nil as UUID?)
                        ForEach(viewModel.game.players) { player in
                            Text(player.name).tag(player.id as UUID?)
                        }
                    }
                }

                Section(header: Text("Development")) {
                    Stepper("Houses: \(houses)", value: $houses, in: 0...4)
                    Stepper("Hotels: \(hotels)", value: $hotels, in: 0...1)
                }

                Section(header: Text("Status")) {
                    Toggle("Mortgaged", isOn: $isMortgaged)
                }

                Section {
                    Button("Save") {
                        // Create a new property instance with the updated values
                        var updatedProperty = property
                        updatedProperty.houses = houses
                        updatedProperty.hotels = hotels
                        updatedProperty.isMortgaged = isMortgaged

                        // Find the selected owner
                        let newOwner = viewModel.game.players.first(where: { $0.id == ownerId })

                        // Update ownership in the view model
                        viewModel.updatePropertyOwner(for: updatedProperty, newOwner: newOwner)

                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Edit \(property.name)")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct EditPropertyStateView_Previews: PreviewProvider {
    static var previews: some View {
        let modelContainer = try! ModelContainer(for: GameRecord.self, PlayerProfile.self, PropertySet.self)
        let game = Game.sampleGame
        let viewModel = GameViewModel(game: game, modelContext: modelContainer.mainContext)

        // Create a binding to a sample property
        @State var property = game.properties[0]

        EditPropertyStateView(viewModel: viewModel, property: $property)
            .modelContainer(modelContainer)
    }
}
