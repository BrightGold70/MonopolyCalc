import Foundation
import SwiftData
import SwiftUI

@MainActor
class GameRecordViewModel: ObservableObject {
    @Published var gameRecords: [GameRecord] = []
    @Published var searchText = ""
    @Published var sortOrder: SortOrder = .date

    private var modelContext: ModelContext

    enum SortOrder {
        case date, score
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchGameRecords()
    }

    func fetchGameRecords() {
        do {
            var descriptor = FetchDescriptor<GameRecord>()

            if !searchText.isEmpty {
                descriptor.predicate = #Predicate { record in
                    record.scores.contains { score in
                        score.playerName.localizedStandardContains(searchText)
                    }
                }
            }

            switch sortOrder {
            case .date:
                descriptor.sortBy = [SortDescriptor(\.date, order: .reverse)]
            case .score:
                // This is a bit more complex as we need to sort by the winner's score.
                // A computed property on GameRecord for winnerNetWorth would be more efficient.
                // For now, we sort in memory.
                var records = try modelContext.fetch(descriptor)
                records.sort {
                    ($0.winner?.netWorth ?? 0) > ($1.winner?.netWorth ?? 0)
                }
                gameRecords = records
                return // Exit early
            }

            gameRecords = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch game records: \(error)")
        }
    }
}
