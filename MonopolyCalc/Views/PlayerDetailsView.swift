import SwiftUI

struct PlayerDetailsView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var cashAdjustment: String = ""

    private var selectedPlayer: Player {
        viewModel.selectedPlayer
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Net Worth and Undo Button
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Net Worth")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("$\(selectedPlayer.netWorth)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.monopolyGreen)
                    }
                    Spacer()
                    Button(action: {
                        viewModel.undoLastTransaction()
                    }) {
                        HStack {
                            Image(systemName: "arrow.uturn.backward")
                            Text("Undo")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.neutralOffWhite)
                        .cornerRadius(20)
                        .shadow(radius: 2)
                    }
                }

                // Financial Details
                VStack(spacing: 15) {
                    Divider()
                    FinancialDetailRow(label: "Cash", value: "$\(selectedPlayer.cash)")
                    AdjustCashView(cashAdjustment: $cashAdjustment, onAdjust: { amount in
                        viewModel.adjustCash(forPlayerIndex: viewModel.game.selectedPlayerIndex, amount: amount)
                        cashAdjustment = ""
                    })
                    Divider()
                    FinancialDetailRow(label: "Property Value", value: "$\(propertyValue)")
                    Divider()
                    FinancialDetailRow(label: "Houses & Hotels", value: "$\(housesAndHotelsValue)")
                }

                // View Cash Transaction Log Button
                Button(action: {}) {
                    HStack {
                        Image(systemName: "list.bullet.rectangle")
                        Text("View Cash Transaction Log")
                    }
                    .font(.headline)
                    .foregroundColor(.monopolyGreen)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.monopolyGreen.opacity(0.1))
                    .cornerRadius(10)
                }

                PropertiesListView(properties: selectedPlayer.properties)
            }
            .padding()
        }
    }

    private var propertyValue: Int {
        selectedPlayer.properties.filter { !$0.isMortgaged }.reduce(0) { $0 + $1.value }
    }

    private var housesAndHotelsValue: Int {
        // This is a simplified calculation. A more accurate one would depend on the cost of houses/hotels for each property.
        selectedPlayer.properties.reduce(0) { $0 + ($1.houses * 50) + ($1.hotels * 250) }
    }
}
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Net Worth and Undo Button
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Net Worth")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("$\(selectedPlayer.netWorth)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.monopolyGreen)
                    }
                    Spacer()
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "arrow.uturn.backward")
                            Text("Undo")
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 2)
                    }
                }

                // Financial Details
                VStack(spacing: 15) {
                    Divider()
                    FinancialDetailRow(label: "Cash", value: "$\(selectedPlayer.cash)")
                    AdjustCashView(cashAdjustment: $cashAdjustment, onAdjust: { amount in
                        // Placeholder for cash adjustment logic
                    })
                    Divider()
                    FinancialDetailRow(label: "Property Value", value: "$\(propertyValue)")
                    Divider()
                    FinancialDetailRow(label: "Houses & Hotels", value: "$\(housesAndHotelsValue)")
                }

                // View Cash Transaction Log Button
                Button(action: {}) {
                    HStack {
                        Image(systemName: "list.bullet.rectangle")
                        Text("View Cash Transaction Log")
                    }
                    .font(.headline)
                    .foregroundColor(.monopolyGreen)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.monopolyGreen.opacity(0.1))
                    .cornerRadius(10)
                }

                PropertiesListView(properties: selectedPlayer.properties)
            }
            .padding()
        }
    }

    private var propertyValue: Int {
        selectedPlayer.properties.filter { !$0.isMortgaged }.reduce(0) { $0 + $1.value }
    }

    private var housesAndHotelsValue: Int {
        // This is a simplified calculation. A more accurate one would depend on the cost of houses/hotels for each property.
        selectedPlayer.properties.reduce(0) { $0 + ($1.houses * 50) + ($1.hotels * 250) }
    }
}

struct FinancialDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct AdjustCashView: View {
    @Binding var cashAdjustment: String
    let onAdjust: (Int) -> Void

    var body: some View {
        VStack {
            TextField("Adjust Cash", text: $cashAdjustment)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            HStack {
                Button(action: {
                    if let amount = Int(cashAdjustment) {
                        onAdjust(-amount)
                    }
                }) {
                    Image(systemName: "minus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.monopolyRed)
                        .clipShape(Circle())
                }

                Button(action: {
                    if let amount = Int(cashAdjustment) {
                        onAdjust(amount)
                    }
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.monopolyGreen)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct PlayerDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDetailsView(viewModel: GameViewModel(game: Game(players: Game.samplePlayers)))
    }
}
