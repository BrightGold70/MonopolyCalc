import SwiftUI
import SwiftData

struct ManagePlayersView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: PlayerManagementViewModel

    @State private var playerToEdit: PlayerProfile?
    @State private var showingEditSheet = false
    @State private var playerToDelete: PlayerProfile?
    @State private var showingDeleteAlert = false

    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: PlayerManagementViewModel(modelContext: modelContext))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundDark.edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    HeaderView {
                        presentationMode.wrappedValue.dismiss()
                    }

                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.players) { player in
                                PlayerManagementRow(
                                    player: player,
                                    onEdit: {
                                        playerToEdit = player
                                        showingEditSheet = true
                                    },
                                    onDelete: {
                                        playerToDelete = player
                                        showingDeleteAlert = true
                                    }
                                )
                            }
                        }
                        .padding()
                    }
                }

                FloatingActionButtons(
                    onAddPlayer: {
                        playerToEdit = nil
                        showingEditSheet = true
                    }
                )
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingEditSheet) {
                CreatePlayerView(playerToEdit: playerToEdit) { name, icon in
                    if let player = playerToEdit {
                        viewModel.updatePlayer(player, name: name, icon: icon)
                    } else {
                        viewModel.addPlayer(name: name, icon: icon)
                    }
                    showingEditSheet = false
                }
            }
            .alert("Remove Player?", isPresented: $showingDeleteAlert, presenting: playerToDelete) { player in
                Button("Remove", role: .destructive) {
                    viewModel.deletePlayer(player)
                }
                Button("Cancel", role: .cancel) {}
            } message: { player in
                Text("Are you sure you want to remove \(player.name)?")
            }
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Subviews

private struct HeaderView: View {
    var onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 20, weight: .semibold))
            }
            .frame(width: 40, height: 40)

            Spacer()
            Text("Manage Players")
                .font(.system(size: 20, weight: .bold))
            Spacer()

            Spacer().frame(width: 40, height: 40)
        }
        .foregroundColor(.textDark)
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

private struct PlayerManagementRow: View {
    let player: PlayerProfile
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: player.icon)
                .font(.system(size: 24))
                .foregroundColor(.primary)
                .frame(width: 48, height: 48)
                .background(Color.primary.opacity(0.2))
                .clipShape(Circle())

            VStack(alignment: .leading) {
                Text(player.name)
                    .font(.system(size: 16, weight: .medium))
                Text("Active") // Placeholder
                    .font(.system(size: 12))
                    .foregroundColor(.textDark.opacity(0.7))
            }

            Spacer()

            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .frame(width: 40, height: 40)
            }

            Button(action: onDelete) {
                Image(systemName: "trash")
                    .frame(width: 40, height: 40)
            }
        }
        .foregroundColor(.textDark)
        .padding(8)
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
    }
}

private struct FloatingActionButtons: View {
    let onAddPlayer: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(spacing: 16) {
                    // TODO: Implement Manage Assets functionality
                    Button(action: {}) {
                        HStack {
                            Text("Manage Assets")
                            Image(systemName: "house.fill")
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                    .disabled(true)

                    Button(action: onAddPlayer) {
                        HStack {
                            Text("Add Player")
                            Image(systemName: "plus")
                        }
                        .padding()
                        .background(Color.accent)
                        .foregroundColor(.white)
                        .cornerRadius(30)
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Preview

struct ManagePlayersView_Previews: PreviewProvider {
    static var previews: some View {
        let container = try! ModelContainer(for: PlayerProfile.self, inMemory: true)
        // Add sample data for preview
        PlayerProfile.samplePlayers.forEach { container.mainContext.insert($0) }

        return ManagePlayersView(modelContext: container.mainContext)
    }
}
