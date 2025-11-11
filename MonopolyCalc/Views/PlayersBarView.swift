import SwiftUI

struct PlayersBarView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(viewModel.game.players.indices, id: \.self) { index in
                    PlayerAvatarView(player: viewModel.game.players[index], isSelected: index == viewModel.game.selectedPlayerIndex)
                        .onTapGesture {
                            viewModel.selectPlayer(at: index)
                        }
                }
            }
            .padding()
        }
        .background(Color.monopolyGreen.opacity(0.9))
    }
}

struct PlayerAvatarView: View {
    let player: Player
    let isSelected: Bool

    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(Circle().stroke(isSelected ? Color.primary : Color.clear, lineWidth: 4))

            Text(player.name)
                .foregroundColor(isSelected ? .white : .white.opacity(0.8))
                .fontWeight(isSelected ? .bold : .medium)

            Text("$\(player.netWorth)")
                .foregroundColor(isSelected ? Color.primary : .white.opacity(0.7))
                .fontWeight(isSelected ? .bold : .regular)
        }
        .padding(.bottom, 10)
        .border(width: isSelected ? 4 : 0, edges: [.bottom], color: .primary)
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}


struct PlayersBarView_Previews: PreviewProvider {
    static var previews: some View {
        PlayersBarView(viewModel: GameViewModel(game: Game(players: Game.samplePlayers)))
    }
}
