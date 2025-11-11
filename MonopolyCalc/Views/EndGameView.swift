import SwiftUI

struct EndGameView: View {
    var winner: Player?

    var body: some View {
        VStack {
            if let winner = winner {
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
        EndGameView(winner: Player(name: "Player 1", avatar: "player1", cash: 1500, properties: []))
    }
}
