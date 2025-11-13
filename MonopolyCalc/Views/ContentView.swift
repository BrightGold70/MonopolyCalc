import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var players: [PlayerProfile]
    @State private var showingPlayerManagement = false
    @State private var selectedTab = "Records"

    var body: some View {
        TabView(selection: $selectedTab) {
            GameRecordView(modelContext: modelContext)
                .tabItem {
                    Label("Records", systemImage: "list.bullet")
                }
                .tag("Records")

            StartGameView(modelContext: modelContext, selectedTab: $selectedTab)
                .tabItem {
                    Label("New Game", systemImage: "plus.circle")
                }
                .tag("New Game")
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
