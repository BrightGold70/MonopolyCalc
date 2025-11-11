import SwiftUI
import SwiftData

struct GameRecordView: View {
    @Query private var gameRecords: [GameRecord]

    var body: some View {
        NavigationStack {
            List(gameRecords) { record in
                VStack(alignment: .leading) {
                    Text("Game on \(record.date.formatted(date: .abbreviated, time: .shortened))")
                        .font(.headline)
                    Text("Winner: \(record.winner?.name ?? "N/A")")
                        .font(.subheadline)
                    Text("\(record.players.count) players")
                        .font(.caption)
                }
            }
            .navigationTitle("Game Records")
        }
    }
}

struct GameRecordView_Previews: PreviewProvider {
    static var previews: some View {
        GameRecordView()
            .modelContainer(for: GameRecord.self, inMemory: true)
    }
}
