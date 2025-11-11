import SwiftUI

struct ContentView: View {
    var body: some View {
        GameBoardSummaryView(viewModel: GameViewModel(game: Game.sampleGame))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
