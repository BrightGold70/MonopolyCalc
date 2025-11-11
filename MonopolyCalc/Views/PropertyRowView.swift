import SwiftUI

struct PropertyRowView: View {
    let property: Property
    let ownerName: String?

    var body: some View {
        HStack {
            HStack {
                Image(systemName: property.color == .railroad ? "tram.fill" : (property.color == .utility ? "lightbulb.fill" : "house.fill"))
                    .foregroundColor(property.color.color)
                    .frame(width: 48, height: 48)
                    .background(property.color.color.opacity(0.2))
                    .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text(property.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(ownerName ?? "Unowned")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Spacer()

            // Icons for houses, hotels, mortgage, monopoly
            HStack {
                if property.isMortgaged {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.red)
                }

                if property.isMonopoly {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }

                if property.hotels > 0 {
                    Image(systemName: "building.2.fill")
                        .foregroundColor(.yellow)
                } else if property.houses > 0 {
                    ForEach(0..<property.houses, id: \.self) { _ in
                        Image(systemName: "house.fill")
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding()
        .background(Color.neutralDarkCharcoal)
        .cornerRadius(10)
    }
}

struct PropertyRowView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyRowView(property: Property(name: "Mediterranean Avenue", value: 60, color: .brown, isMortgaged: true, houses: 3, rent: 2, houseCost: 50, hotelCost: 250, isMonopoly: true), ownerName: "Player 1")
            .preferredColorScheme(.dark)
    }
}
