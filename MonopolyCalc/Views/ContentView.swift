import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
