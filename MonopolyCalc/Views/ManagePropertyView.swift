import SwiftUI
import SwiftData

struct ManagePropertyView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext

    var propertyToEdit: Property?

    @State private var name = ""
    @State private var originalValue: Double = 0
    @State private var color: PropertyColor?
    @State private var group: PropertyGroup?
    @State private var costOfHouse: Double = 0
    @State private var costOfHotel: Double = 0

    @Query private var colors: [PropertyColor]
    @Query private var groups: [PropertyGroup]

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    init(viewModel: GameViewModel, propertyToEdit: Property? = nil) {
        self.viewModel = viewModel
        self.propertyToEdit = propertyToEdit

        if let property = propertyToEdit {
            _name = State(initialValue: property.name)
            _originalValue = State(initialValue: property.originalValue)
            _color = State(initialValue: property.color)
            _group = State(initialValue: property.group)
            _costOfHouse = State(initialValue: property.costOfHouse)
            _costOfHotel = State(initialValue: property.costOfHotel)
        }
    }

    var isFormValid: Bool {
        !name.isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Property Details")) {
                    TextField("Name", text: $name)
                    TextField("Value", value: $originalValue, formatter: numberFormatter)
                        .keyboardType(.decimalPad)

                    Picker("Color", selection: $color) {
                        ForEach(colors) { color in
                            Text(color.name.capitalized).tag(color as PropertyColor?)
                        }
                    }

                    Picker("Group", selection: $group) {
                        ForEach(groups) { group in
                            Text(group.name.capitalized).tag(group as PropertyGroup?)
                        }
                    }
                }

                Section(header: Text("Costs")) {
                    TextField("House Cost", value: $costOfHouse, formatter: numberFormatter)
                        .keyboardType(.decimalPad)
                    TextField("Hotel Cost", value: $costOfHotel, formatter: numberFormatter)
                        .keyboardType(.decimalPad)
                }

                Section {
                    Button("Save") {
                        guard let color = color, let group = group else {
                            // Handle the case where color or group is not selected
                            return
                        }

                        if var property = propertyToEdit {
                            // Property exists, update it
                            property.name = name
                            property.originalValue = originalValue
                            property.color = color
                            property.group = group
                            property.costOfHouse = costOfHouse
                            property.costOfHotel = costOfHotel
                            viewModel.updateProperty(property)
                        } else {
                            // This is a new property
                            let newProperty = Property(name: name, originalValue: originalValue, houses: 0, costOfHouse: costOfHouse, hotels: 0, costOfHotel: costOfHotel, isOwned: false, index: 0, color: color, group: group, bonus: 0, isMortgaged: false)
                            viewModel.addProperty(newProperty)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
            .navigationTitle(propertyToEdit == nil ? "Add Property" : "Edit Property")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ManagePropertyView_Previews: PreviewProvider {
    static var previews: some View {
        let modelContainer = try! ModelContainer(for: GameRecord.self, PlayerProfile.self, PropertySet.self)
        let game = Game.sampleGame
        let viewModel = GameViewModel(game: game, modelContext: modelContainer.mainContext)
        ManagePropertyView(viewModel: viewModel)
            .modelContainer(modelContainer)
    }
}
