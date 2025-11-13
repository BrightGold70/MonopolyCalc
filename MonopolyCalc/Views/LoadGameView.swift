import SwiftUI
import SwiftData

struct LoadGameView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode

    @Query(sort: \SavedGame.date, order: .reverse) private var savedGames: [SavedGame]

    var onGameLoaded: (SavedGame) -> Void

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.edgesIgnoringSafeArea(.all)

                if savedGames.isEmpty {
                    VStack {
                        Image(systemName: "tray.and.arrow.down.fill")
                            .font(.system(size: 60))
                        Text("No Saved Games")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Save a game in progress to resume it later.")
                            .multilineTextAlignment(.center)
                    }
                    .foregroundColor(.white.opacity(0.6))
                    .padding()
                } else {
                    List {
                        ForEach(savedGames) { savedGame in
                            Button(action: { onGameLoaded(savedGame) }) {
                                VStack(alignment: .leading) {
                                    Text("Game from \(savedGame.date, style: .date)")
                                        .font(.headline)
                                    Text("Players: \(savedGame.players.map { $0.name }.joined(separator: ", "))")
                                        .font(.subheadline)
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteGame(savedGame)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Load Game")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .preferredColorScheme(.dark)
        }
    }

    private func deleteGame(_ game: SavedGame) {
        modelContext.delete(game)
    }
}
