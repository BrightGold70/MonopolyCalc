import SwiftUI

struct ManagePropertyView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode

    var propertyToEdit: Property?

    @State private var name = ""
    @State private var originalValue: Double = 0
    @State private var color = PropertyColor.brown
    @State private var group = PropertyGroup.group1
    @State private var costOfHouse: Double = 0
    @State private var costOfHotel: Double = 0

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
                        ForEach(PropertyColor.allCases) { color in
                            Text(color.rawValue.capitalized).tag(color)
                        }
                    }
                    Picker("Group", selection: $group) {
                        ForEach(PropertyGroup.allCases) { group in
                            Text(group.rawValue.capitalized).tag(group)
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
        ManagePropertyView(viewModel: GameViewModel(game: Game.sampleGame))
    }
}
