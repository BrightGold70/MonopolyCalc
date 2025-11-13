import SwiftUI
import SwiftData

struct GameRecordCardView: View {
    let record: GameRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(record.date, style: .date)
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))

            HStack {
                Image(systemName: "trophy.fill")
                    .foregroundColor(.yellow)

                if let winner = record.winner {
                    Text("Winner: \(winner.playerName) - $\(winner.netWorth, specifier: "%.2f")")
                        .font(.headline)
                        .fontWeight(.bold)
                } else {
                    Text("No Winner")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }

            Text("Players: \(record.playerNames)")
                .font(.subheadline)

            Text("Tap to see full game details")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .padding(.top, 4)
        }
        .padding()
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
        .foregroundColor(.white)
    }
}

struct GameRecordCardView_Previews: PreviewProvider {
    static var previews: some View {
        let container = try! ModelContainer(for: GameRecord.self, inMemory: true)
        let scores = [PlayerScore(playerName: "Player 1", netWorth: 2500), PlayerScore(playerName: "Player 2", netWorth: 1500)]
        let record = GameRecord(date: Date(), scores: scores)
        container.mainContext.insert(record)

        return GameRecordCardView(record: record)
            .background(Color.backgroundDark)
    }
}
