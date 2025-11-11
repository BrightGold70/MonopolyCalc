import SwiftUI

struct EndGameView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack {
            if let winner = viewModel.calculateWinner() {
                Text("Congratulations!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("\(winner.name) is the winner!")
                    .font(.title)
                Text("Net Worth: $\(winner.netWorth)")
                    .font(.title2)
            } else {
                Text("No winner could be determined.")
                    .font(.title)
            }
        }
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView(viewModel: GameViewModel(game: Game(players: [
            Player(name: "Player 1", avatar: "player1", cash: 1500, properties: [])
        ], properties: [])))
    }
}
