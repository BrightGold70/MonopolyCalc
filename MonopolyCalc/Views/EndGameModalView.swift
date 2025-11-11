import SwiftUI

struct EndGameModalView: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: GameViewModel
    @State private var cashCounts: [UUID: String] = [:]
    @State private var winner: Player?

    var body: some View {
        VStack {
            if let winner = winner {
                WinnerView(winner: winner, isPresented: $isPresented)
            } else {
                VStack {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Final Cash Count")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Enter the final cash amount for each player to calculate the winner.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()

                    List(viewModel.game.players) { player in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(player.name)
                                    .font(.headline)
                                TextField("Enter cash", text: Binding(
                                    get: { self.cashCounts[player.id, default: ""] },
                                    set: { self.cashCounts[player.id] = $0 }
                                ))
                                .keyboardType(.numberPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    }

                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("Cancel")
                                .font(.headline)
                                .foregroundColor(.primary)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(15)
                        }

                        Button(action: {
                            winner = viewModel.calculateWinner(cashCounts: cashCounts)
                        }) {
                            Text("Calculate Winner")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.monopolyRed)
                                .cornerRadius(15)
                        }
                    }
                    .padding()
                }
                .background(Color(UIColor.systemBackground))
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding(30)
            }
        }
    }
}

struct WinnerView: View {
    let winner: Player
    @Binding var isPresented: Bool

    var body: some View {
        VStack {
            Text("🎉 Winner! 🎉")
                .font(.largeTitle)
                .fontWeight(.bold)

            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
                .padding()

            Text(winner.name)
                .font(.title)
                .fontWeight(.bold)

            Text("Net Worth: $\(winner.netWorth)")
                .font(.headline)
                .foregroundColor(.secondary)

            Button(action: {
                isPresented = false
            }) {
                Text("New Game")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.monopolyGreen)
                    .cornerRadius(15)
            }
            .padding()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

struct EndGameModalView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameModalView(isPresented: .constant(true), viewModel: GameViewModel(game: Game(players: Game.samplePlayers)))
    }
}
