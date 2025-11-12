import SwiftUI

struct CreatePlayerView: View {
    @Environment(\.presentationMode) var presentationMode

    var playerToEdit: PlayerProfile?

    @State private var name = ""
    @State private var selectedIcon = "person.fill"
    let icons = ["person.fill", "hare.fill", "car.fill", "dog.fill", "airplane", "gamecontroller.fill", "joystick.fill"]

    var onSave: (String, String) -> Void

    init(playerToEdit: PlayerProfile? = nil, onSave: @escaping (String, String) -> Void) {
        self.playerToEdit = playerToEdit
        self.onSave = onSave

        if let player = playerToEdit {
            _name = State(initialValue: player.name)
            _selectedIcon = State(initialValue: player.icon)
        }
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Player Details")) {
                    TextField("Name", text: $name)

                    Picker("Icon", selection: $selectedIcon) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon).tag(icon)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section {
                    Button("Save") {
                        onSave(name, selectedIcon)
                    }
                    .disabled(name.isEmpty)
                }
            }
            .navigationTitle(playerToEdit == nil ? "New Player" : "Edit Player")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
