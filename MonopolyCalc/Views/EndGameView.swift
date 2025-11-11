import SwiftUI
import SwiftData

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
                Text("Net Worth: $\(viewModel.calculateNetWorth(for: winner), specifier: "%.2f")")
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
        let modelContainer = try! ModelContainer(for: GameRecord.self, PlayerProfile.self, PropertySet.self)
        let game = Game.sampleGame
        let viewModel = GameViewModel(game: game, modelContext: modelContainer.mainContext)
        EndGameView(viewModel: viewModel)
            .modelContainer(modelContainer)
    }
}
