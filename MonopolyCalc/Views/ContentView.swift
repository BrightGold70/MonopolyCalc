import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var players: [PlayerProfile]
    @State private var showingPlayerManagement = false

    var body: some View {
        TabView {
            GameRecordView()
                .tabItem {
                    Label("Records", systemImage: "list.bullet")
                }

            StartGameView(modelContext: modelContext)
                .tabItem {
                    Label("New Game", systemImage: "plus.circle")
                }
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: checkPlayerCount)
        .fullScreenCover(isPresented: $showingPlayerManagement) {
            ManagePlayersView(modelContext: modelContext)
        }
    }

    private func checkPlayerCount() {
        if players.count < 2 {
            showingPlayerManagement = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
