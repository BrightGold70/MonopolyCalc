import SwiftUI

struct PropertiesListView: View {
    let properties: [Property]

    var body: some View {
        DisclosureGroup("Properties & Assets") {
            VStack(spacing: 15) {
                // Search and Filter
                HStack {
                    TextField("Search properties...", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button(action: {}) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                    }

                    Button(action: {}) {
                        Image(systemName: "arrow.up.arrow.down.circle")
                    }
                }

                // Properties List
                ForEach(properties) { property in
                    PropertyRowView(property: property)
                }
            }
        }
        .padding()
    }
}

struct PropertyRowView: View {
    let property: Property

    var body: some View {
        HStack {
            Rectangle()
                .fill(colorForProperty(property.color))
                .frame(width: 10)

            VStack(alignment: .leading) {
                Text(property.name)
                    .font(.headline)

                if property.isMortgaged {
                    Text("Mortgaged")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if property.hotels > 0 {
                    Text("\(property.hotels) Hotel\(property.hotels > 1 ? "s" : "")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else if property.houses > 0 {
                    Text("\(property.houses) House\(property.houses > 1 ? "s" : "")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text("$\(property.value)")
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .background(Color.neutralOffWhite)
        .cornerRadius(10)
        .shadow(radius: 2)
        .opacity(property.isMortgaged ? 0.6 : 1.0)
    }

    private func colorForProperty(_ color: PropertyColor) -> Color {
        switch color {
        case .brown: return .brown
        case .lightBlue: return .blue.opacity(0.5)
        case .pink: return .pink
        case .orange: return .orange
        case .red: return .red
        case .yellow: return .yellow
        case .green: return .green
        case .darkBlue: return .blue
        }
    }
}

struct PropertiesListView_Previews: PreviewProvider {
    static var previews: some View {
        PropertiesListView(properties: Game.samplePlayers[0].properties)
    }
}
