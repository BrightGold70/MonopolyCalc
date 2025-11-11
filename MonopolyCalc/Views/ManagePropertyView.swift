import SwiftUI

struct ManagePropertyView: View {
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.presentationMode) var presentationMode

    var propertyToEdit: Property?

    @State private var name = ""
    @State private var value: Int = 0
    @State private var color = PropertyColor.brown
    @State private var rent: Int = 0
    @State private var houseCost: Int = 0
    @State private var hotelCost: Int = 0

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
            _value = State(initialValue: property.value)
            _color = State(initialValue: property.color)
            _rent = State(initialValue: property.rent)
            _houseCost = State(initialValue: property.houseCost)
            _hotelCost = State(initialValue: property.hotelCost)
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
                    TextField("Value", value: $value, formatter: numberFormatter)
                        .keyboardType(.numberPad)
                    Picker("Color", selection: $color) {
                        ForEach(PropertyColor.allCases) { color in
                            Text(color.rawValue.capitalized).tag(color)
                        }
                    }
                }

                Section(header: Text("Rent and Costs")) {
                    TextField("Rent", value: $rent, formatter: numberFormatter)
                        .keyboardType(.numberPad)
                    TextField("House Cost", value: $houseCost, formatter: numberFormatter)
                        .keyboardType(.numberPad)
                    TextField("Hotel Cost", value: $hotelCost, formatter: numberFormatter)
                        .keyboardType(.numberPad)
                }

                Section {
                    Button("Save") {
                        var property = propertyToEdit ?? Property(name: name, value: value, color: color, rent: rent, houseCost: houseCost, hotelCost: hotelCost)
                        property.name = name
                        property.value = value
                        property.color = color
                        property.rent = rent
                        property.houseCost = houseCost
                        property.hotelCost = hotelCost

                        if propertyToEdit == nil {
                            viewModel.addProperty(property)
                        } else {
                            viewModel.updateProperty(property)
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
        ManagePropertyView(viewModel: GameViewModel(game: Game(players: [], properties: [])))
    }
}
