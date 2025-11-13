import SwiftUI
import SwiftData

struct EndGameView: View {
    @ObservedObject var viewModel: GameViewModel
    @Binding var selectedTab: String
    var onFinish: () -> Void

    private var rankings: [PlayerRanking] {
        viewModel.getPlayerRankings()
    }

    private var winner: PlayerRanking? {
        rankings.first
    }

    var body: some View {
        ZStack {
            Color.backgroundDark.edgesIgnoringSafeArea(.all)
            ConfettiView()

            VStack(spacing: 0) {
                Header { onFinish() }

                ScrollView {
                    VStack(spacing: 24) {
                        WinnerText(winner: winner)
                        WinnerAvatar(winner: winner)

                        Text("Final Scores")
                            .font(.sm)
                            .fontWeight(.bold)
                            .kerning(1.5)
                            .foregroundColor(.white.opacity(0.6))
                            .textCase(.uppercase)

                        ForEach(Array(rankings.enumerated()), id: \.element.id) { index, ranking in
                            PlayerScoreRowView(ranking: ranking, rank: index + 1)
                        }
                    }
                    .padding()
                }

                BottomButtons(onNewGame: {
                    selectedTab = "New Game"
                    onFinish()
                })
            }
        }
        .preferredColorScheme(.dark)
    }
}


// MARK: - Subviews
private struct Header: View {
    var onHome: () -> Void

    var body: some View {
        HStack {
            Button(action: onHome) {
                Image(systemName: "house.fill")
                    .font(.title)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
        }
        .padding()
    }
}

private struct WinnerText: View {
    let winner: PlayerRanking?

    var body: some View {
        Text(winner != nil ? "WINNER!" : "GAME OVER")
            .font(.system(size: 50, weight: .bold))
            .foregroundColor(.primary)
            .tracking(2)
            .padding(.vertical)
    }
}

private struct WinnerAvatar: View {
    let winner: PlayerRanking?

    var body: some View {
        VStack {
            if let winner = winner {
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: "person.crop.circle.fill") // Placeholder
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 128, height: 128)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.yellow, lineWidth: 4))

                    Image(systemName: "crown.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.yellow)
                        .padding(8)
                        .background(Color.backgroundDark)
                        .clipShape(Circle())
                        .offset(x: 10, y: 10)
                }

                Text(winner.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                Text("Final Net Worth")
                    .font(.base)
                    .foregroundColor(.white.opacity(0.7))

                Text("$\(winner.netWorth, specifier: "%.2f")")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.primary)
            }
        }
    }
}


private struct BottomButtons: View {
    var onNewGame: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Button(action: {}) { // Placeholder for Share
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("Share Results")
                }
                .font(.lg)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primary)
                .foregroundColor(.backgroundDark)
                .cornerRadius(16)
            }
            .disabled(true)
            .opacity(0.6)

            Button(action: onNewGame) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Start New Game")
                }
                .font(.lg)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.primary.opacity(0.2))
                .foregroundColor(.primary)
                .cornerRadius(16)
            }
        }
        .padding()
    }
}

// MARK: - Previews

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        let container = try! ModelContainer(for: GameRecord.self, PlayerProfile.self, PropertySet.self)
        let game = Game.sampleGame

        if let player1 = game.players.first {
            player1.properties.append(game.properties[0])
            player1.properties.append(game.properties[1])
        }

        let viewModel = GameViewModel(game: game, modelContext: container.mainContext)

        EndGameView(viewModel: viewModel, selectedTab: .constant("New Game"), onFinish: {})
            .modelContainer(container)
    }
}
