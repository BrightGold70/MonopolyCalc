import SwiftUI

struct ScoreboardView: View {
    @StateObject private var viewModel = GameViewModel(game: Game(players: Game.samplePlayers))
    @State private var isEndGameModalPresented = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    HeaderView()

                    PlayersBarView(viewModel: viewModel)

                    PlayerDetailsTabView(viewModel: viewModel)

                    PlayerDetailsView(viewModel: viewModel)

                    Spacer()

                    BottomNavBarView(isEndGameModalPresented: $isEndGameModalPresented)
                }
                .navigationBarHidden(true)
                .background(Color(.systemGroupedBackground))
                .edgesIgnoringSafeArea(.bottom)

                if isEndGameModalPresented {
                    EndGameModalView(isPresented: $isEndGameModalPresented, viewModel: viewModel)
                }
            }
        }
    }
}

struct ScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreboardView()
    }
}
