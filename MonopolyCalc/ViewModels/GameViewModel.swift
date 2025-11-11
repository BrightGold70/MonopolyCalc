import Foundation

class GameViewModel: ObservableObject {
    @Published var game: Game
    private var lastTransaction: (playerIndex: Int, amount: Int)?

    init(game: Game) {
        self.game = game
    }

    var selectedPlayer: Player {
        game.players[game.selectedPlayerIndex]
    }

    func selectPlayer(at index: Int) {
        game.selectedPlayerIndex = index
    }

    func adjustCash(forPlayerIndex playerIndex: Int, amount: Int) {
        guard game.players.indices.contains(playerIndex) else { return }
        game.players[playerIndex].cash += amount
        lastTransaction = (playerIndex, amount)
    }

    func undoLastTransaction() {
        guard let transaction = lastTransaction else { return }
        adjustCash(forPlayerIndex: transaction.playerIndex, amount: -transaction.amount)
        lastTransaction = nil
    }

    func calculateWinner(cashCounts: [UUID: String]) -> Player? {
        var finalScores: [Player: Int] = [:]
        for player in game.players {
            if let cashString = cashCounts[player.id], let cash = Int(cashString) {
                finalScores[player] = player.netWorth - player.cash + cash
            } else {
                finalScores[player] = player.netWorth
            }
        }
        return finalScores.max(by: { $0.value < $1.value })?.key
    }
}

extension Player: Hashable {
    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
