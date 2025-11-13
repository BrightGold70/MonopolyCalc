import SwiftUI
import SwiftData

struct StartGameView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: StartGameViewModel
    @Binding var selectedTab: String

    @State private var isGameStarted = false
    @State private var showingCreatePlayerSheet = false
    @State private var showingManagePlayersSheet = false

    init(modelContext: ModelContext, selectedTab: Binding<String>) {
        _viewModel = StateObject(wrappedValue: StartGameViewModel(modelContext: modelContext))
        _selectedTab = selectedTab
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundDark.edgesIgnoringSafeArea(.all)

                VStack(spacing: 0) {
                    HeaderView {
                        showingManagePlayersSheet = true
                    }

                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            InstructionsView()
                            GameSetupTemplateView()
                            StartingCashView(startingCash: $viewModel.startingCash)
                            if let selectedSet = viewModel.selectedPropertySet {
                                PropertySetView(selectedSet: .constant(selectedSet), sets: viewModel.propertySets)
                            }
                            PlayerSelectionView(viewModel: viewModel, showingCreatePlayerSheet: $showingCreatePlayerSheet)
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                        .padding(.bottom, 150)
                    }
                }

                BottomBarView(
                    playerCount: viewModel.selectedPlayers.count,
                    onStartGame: {
                        if !viewModel.selectedPlayers.isEmpty {
                            isGameStarted = true
                        }
                    }
                )
            }
            .navigationDestination(isPresented: $isGameStarted) {
                if let game = viewModel.createGame() {
                    GameBoardSummaryView(viewModel: GameViewModel(game: game, modelContext: modelContext), selectedTab: $selectedTab)
                }
            }
            .sheet(isPresented: $showingCreatePlayerSheet) {
                CreatePlayerView { name, icon in
                    viewModel.createNewPlayer(name: name, icon: icon)
                    showingCreatePlayerSheet = false
                }
            }
            .sheet(isPresented: $showingManagePlayersSheet) {
                ManagePlayersView(modelContext: modelContext)
            }
            .preferredColorScheme(.dark)
        }
        .onAppear {
            viewModel.fetchData()
        }
    }
}

// MARK: - Subviews

private struct HeaderView: View {
    var onManagePlayers: () -> Void

    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "arrow.backward")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.textDark)
            }
            .frame(width: 40, height: 40)

            Spacer()

            Text("New Game")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.textDark)

            Spacer()

            Button(action: onManagePlayers) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.textDark)
            }
            .frame(width: 40, height: 40)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}

private struct InstructionsView: View {
    var body: some View {
        Text("Set up your game by selecting players, starting cash, and a property set.")
            .font(.system(size: 14))
            .foregroundColor(.primary)
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(Color.primary.opacity(0.1))
            .cornerRadius(12)
    }
}

private struct GameSetupTemplateView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Game Setup Template")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.textDark)
                Spacer()
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "bookmark")
                        Text("Save Current")
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                }
            }

            CustomPicker(
                icon: "tag",
                options: ["Custom Setup", "Family Game Night", "Quick Match"],
                selection: .constant("Custom Setup")
            )
        }
    }
}

private struct StartingCashView: View {
    @Binding var startingCash: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Starting Cash")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.textDark)

            CustomTextField(
                icon: "dollarsign.circle",
                placeholder: "e.g. 1500",
                value: $startingCash
            )

            Text("This amount will be applied to all players.")
                .font(.system(size: 12))
                .foregroundColor(.textDark.opacity(0.6))
                .padding(.leading, 4)
        }
    }
}

private struct PropertySetView: View {
    @Binding var selectedSet: PropertySet
    let sets: [PropertySet]

    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Property Set")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.textDark)

            CustomPicker(
                icon: "map",
                options: sets.map { $0.name },
                selection: Binding<String>(
                    get: { selectedSet.name },
                    set: { newName in
                        if let newSet = sets.first(where: { $0.name == newName }) {
                            selectedSet = newSet
                        }
                    }
                )
            )

            VStack(spacing: 0) {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text("Preview \"\(selectedSet.name)\"")
                            .font(.system(size: 14, weight: .medium))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    }
                    .foregroundColor(.textDark)
                    .padding(12)
                }

                if isExpanded {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 8) {
                            ForEach(selectedSet.properties) { property in
                                HStack(spacing: 8) {
                                    Rectangle()
                                        .fill(property.color?.color ?? .gray)
                                        .frame(width: 20, height: 20)
                                        .cornerRadius(4)
                                    Text(property.name)
                                        .font(.system(size: 12))
                                        .foregroundColor(.textDark)
                                }
                            }
                        }
                        .padding(12)
                        .background(Color.black.opacity(0.2))
                    }
                    .frame(maxHeight: 150)
                }
            }
            .background(Color.black.opacity(0.2))
            .cornerRadius(12)
        }
    }
}


private struct PlayerSelectionView: View {
    @ObservedObject var viewModel: StartGameViewModel
    @Binding var showingCreatePlayerSheet: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Selected Players")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.textDark)

                if viewModel.selectedPlayers.isEmpty {
                    Text("No players selected yet.")
                        .font(.system(size: 14))
                        .foregroundColor(.textDark.opacity(0.6))
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.black.opacity(0.1))
                        .cornerRadius(12)
                } else {
                    ForEach(viewModel.selectedPlayers) { player in
                        PlayerRow(player: player, isSelected: true, action: {
                            viewModel.deselectPlayer(player)
                        })
                    }
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Available Players")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.textDark)

                let available = viewModel.availablePlayers.filter { p in
                    !viewModel.selectedPlayers.contains(where: { $0.id == p.id })
                }

                ForEach(available) { player in
                    PlayerRow(player: player, isSelected: false, action: {
                        viewModel.selectPlayer(player)
                    })
                }

                Button(action: {
                    showingCreatePlayerSheet = true
                }) {
                    HStack(spacing: 16) {
                        Image(systemName: "person.badge.plus")
                            .font(.system(size: 24))
                            .frame(width: 48, height: 48)
                            .background(Color.gray.opacity(0.3))
                            .clipShape(Circle())

                        Text("Create New Player")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(.textDark.opacity(0.8))
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 2, dash: [6]))
                    )
                }
            }
        }
    }
}

private struct PlayerRow: View {
    let player: PlayerProfile
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
                        .foregroundColor(.textDark)
                    Text("\(player.gamesPlayed) games played")
                        .font(.system(size: 12))
                        .foregroundColor(.textDark.opacity(0.7))
                }

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .primary : .gray)
                    .font(.system(size: 24))
                    .frame(width: 40, height: 40)
            }
            .padding(8)
            .background(isSelected ? Color.primary.opacity(0.15) : Color.black.opacity(0.2))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.primary : Color.clear, lineWidth: 2)
            )
        }
    }
}


private struct BottomBarView: View {
    let playerCount: Int
    let onStartGame: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 12) {
                Button(action: onStartGame) {
                    HStack {
                        Text("Start Game (\(playerCount))")
                            .font(.system(size: 16, weight: .bold))
                        Image(systemName: "arrow.right")
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(playerCount > 0 ? Color.primary : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(28)
                }
                .disabled(playerCount == 0)

                Button(action: {}) {
                    Image(systemName: "sparkles")
                        .frame(width: 56, height: 56)
                        .background(Color.primary.opacity(0.2))
                        .foregroundColor(.primary)
                        .clipShape(Circle())
                }

                Button(action: {}) {
                    Image(systemName: "gear")
                        .frame(width: 56, height: 56)
                        .background(Color.black.opacity(0.2))
                        .foregroundColor(.textDark.opacity(0.7))
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(.regularMaterial)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

private struct CustomPicker: View {
    let icon: String
    let options: [String]
    @Binding var selection: String

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: icon)
                .foregroundColor(.textDark.opacity(0.5))
                .frame(width: 44, height: 44)

            Picker("", selection: $selection) {
                ForEach(options, id: \.self) {
                    Text($0)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .accentColor(.textDark)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, -8)
        }
        .frame(height: 60)
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
    }
}

private struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var value: Double

    private static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }

    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: icon)
                .foregroundColor(.textDark.opacity(0.5))
                .frame(width: 44, height: 44)

            TextField(placeholder, value: $value, formatter: Self.formatter)
                .keyboardType(.numberPad)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.textDark)
                .padding(.trailing, 16)
        }
        .frame(height: 60)
        .background(Color.black.opacity(0.2))
        .cornerRadius(12)
    }
}

// MARK: - Preview

struct StartGameView_Previews: PreviewProvider {
    static var previews: some View {
        StartGameView(modelContext: try! ModelContainer(for: [PlayerProfile.self, PropertySet.self]).mainContext, selectedTab: .constant("New Game"))
    }
}
