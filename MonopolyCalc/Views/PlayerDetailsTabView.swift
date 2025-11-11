import SwiftUI

struct PlayerDetailsTabView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        HStack {
            ForEach(viewModel.game.players.indices, id: \.self) { index in
                Button(action: {
                    viewModel.selectPlayer(at: index)
                }) {
                    Text(viewModel.game.players[index].name)
                        .font(.headline)
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                        .foregroundColor(index == viewModel.game.selectedPlayerIndex ? Color.monopolyGreen : .gray)
                        .border(width: index == viewModel.game.selectedPlayerIndex ? 3 : 0, edges: [.bottom], color: .monopolyGreen)
                }
            }
        }
        .background(Color.neutralOffWhite)
        .shadow(radius: 1)
    }
}

struct PlayerDetailsTabView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerDetailsTabView(viewModel: GameViewModel(game: Game(players: Game.samplePlayers)))
    }
}
