import SwiftUI
import SwiftData

struct GameRecordView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: GameRecordViewModel

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: GameRecordViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundDark.edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    Header()

                    SearchBar(searchText: $viewModel.searchText)
                    SortButtons(sortOrder: $viewModel.sortOrder)

                    ScrollView {
                        if viewModel.gameRecords.isEmpty {
                            EmptyStateView()
                        } else {
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.gameRecords) { record in
                                    GameRecordCardView(record: record)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .onChange(of: viewModel.searchText) { _, _ in viewModel.fetchGameRecords() }
            .onChange(of: viewModel.sortOrder) { _, _ in viewModel.fetchGameRecords() }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Subviews

private struct Header: View {
    var body: some View {
        HStack {
            Image(systemName: "arrow.backward")
                .font(.system(size: 20, weight: .semibold))
            Spacer()
            Text("Game History")
                .font(.system(size: 20, weight: .bold))
            Spacer()
            Spacer().frame(width: 24)
        }
        .foregroundColor(.white)
        .padding()
    }
}

private struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search by player name", text: $searchText)
        }
        .foregroundColor(.white.opacity(0.8))
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

private struct SortButtons: View {
    @Binding var sortOrder: GameRecordViewModel.SortOrder

    var body: some View {
        HStack {
            Button(action: { sortOrder = .date }) {
                HStack {
                    Image(systemName: "calendar")
                    Text("Sort by Date")
                    Image(systemName: sortOrder == .date ? "chevron.down" : "")
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(sortOrder == .date ? Color.primary.opacity(0.2) : Color.white.opacity(0.1))
                .foregroundColor(sortOrder == .date ? .primary : .white)
                .cornerRadius(20)
            }

            Button(action: { sortOrder = .score }) {
                HStack {
                    Image(systemName: "star.fill")
                    Text("Sort by Score")
                    Image(systemName: sortOrder == .score ? "chevron.down" : "")
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(sortOrder == .score ? Color.primary.opacity(0.2) : Color.white.opacity(0.1))
                .foregroundColor(sortOrder == .score ? .primary : .white)
                .cornerRadius(20)
            }
            Spacer()
        }
        .padding()
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 60))
            Text("No Games Found")
                .font(.title)
                .fontWeight(.bold)
            Text("Finish a game and your records will show up here.")
                .multilineTextAlignment(.center)
            Spacer()
        }
        .foregroundColor(.white.opacity(0.6))
        .padding()
    }
}

// MARK: - Preview

struct GameRecordView_Previews: PreviewProvider {
    static var previews: some View {
        let container = try! ModelContainer(for: GameRecord.self, inMemory: true)
        // Add sample data for preview
        let scores = [PlayerScore(playerName: "Test Player", netWorth: 2500)]
        let record = GameRecord(date: Date(), scores: scores)
        container.mainContext.insert(record)

        return GameRecordView(modelContext: container.mainContext)
    }
}
