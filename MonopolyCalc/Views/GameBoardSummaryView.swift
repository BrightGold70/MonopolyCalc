import SwiftUI
import SwiftData

struct GameBoardSummaryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: GameViewModel
    @Binding var selectedTab: String

    @State private var searchText = ""
    @State private var showEndGameAlert = false
    @State private var showingEndGameScreen = false

    @State private var selectedFilter: FilterType = .none
    @State private var sortOrder: SortOrder = .name
    @State private var selectedGroup: PropertyGroup? = nil

    @State private var showingManagePropertySheet = false
    @State private var showingFilterSheet = false
    @State private var showingSortSheet = false

    @State private var navigationPath = NavigationPath()

    enum FilterType {
        case none, owned, unowned, mortgaged
    }

    enum SortOrder {
        case name, value
    }

    var groupedProperties: [PropertyGroup: [Property]] {
        Dictionary(grouping: filteredAndSortedProperties, by: { $0.group! })
    }

    var filteredAndSortedProperties: [Property] {
        var properties = viewModel.game.properties

        switch selectedFilter {
        case .owned:
            properties = properties.filter { viewModel.getOwner(of: $0) != nil }
        case .unowned:
            properties = properties.filter { viewModel.getOwner(of: $0) == nil }
        case .mortgaged:
            properties = properties.filter { $0.isMortgaged }
        case .none:
            break
        }

        if let group = selectedGroup {
            properties = properties.filter { $0.group == group }
        }

        switch sortOrder {
        case .name:
            properties.sort { $0.name < $1.name }
        case .value:
            properties.sort { $0.originalValue > $1.originalValue }
        }

        if !searchText.isEmpty {
            properties = properties.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }

        return properties
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color.backgroundDark.edgesIgnoringSafeArea(.all)

                VStack {
                    HeaderView(onBack: { presentationMode.wrappedValue.dismiss() })

                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.primary)
                        TextField("Search for a property or player...", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.neutralDarkCharcoal)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            CapsuleButton(label: "Filter", icon: "line.3.horizontal.decrease.circle", action: { showingFilterSheet = true })
                            CapsuleButton(label: "Sort", icon: "arrow.up.arrow.down.circle", action: { showingSortSheet = true })
                            CapsuleButton(label: "Owned", isSelected: selectedFilter == .owned, action: { selectedFilter = selectedFilter == .owned ? .none : .owned })
                            CapsuleButton(label: "Unowned", isSelected: selectedFilter == .unowned, action: { selectedFilter = selectedFilter == .unowned ? .none : .unowned })
                            CapsuleButton(label: "Mortgaged", isSelected: selectedFilter == .mortgaged, action: { selectedFilter = selectedFilter == .mortgaged ? .none : .mortgaged })
                        }
                        .padding(.horizontal)
                    }

                    ScrollView {
                        ForEach(groupedProperties.keys.sorted(by: { $0.name < $1.name }), id: \.self) { group in
                            VStack(alignment: .leading) {
                                Text(group.name.capitalized)
                                    .font(.title2).fontWeight(.bold).foregroundColor(.white)
                                    .padding(.leading)

                                ForEach(groupedProperties[group]!) { property in
                                    NavigationLink(value: property) {
                                        PropertyRowView(property: property, owner: viewModel.getOwner(of: property))
                                            .padding(.horizontal)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }

                BottomNavBar(
                    onSave: {
                        viewModel.saveInProgressGame()
                        presentationMode.wrappedValue.dismiss()
                    },
                    onEndGame: { showEndGameAlert = true }
                )
            }
            .navigationBarHidden(true)
            .navigationDestination(for: Property.self) { property in
                PropertyDetailView(property: property, viewModel: viewModel)
            }
            .sheet(isPresented: $showingManagePropertySheet) {
                // A bit of a hack to get a binding for the sheet
                if let firstProp = viewModel.game.properties.first {
                    ManagePropertyView(viewModel: viewModel, propertyToEdit: firstProp)
                }
            }
            .sheet(isPresented: $showingFilterSheet) {
                FilterView(selectedFilter: $selectedFilter, selectedGroup: $selectedGroup)
            }
            .sheet(isPresented: $showingSortSheet) {
                SortView(sortOrder: $sortOrder)
            }
            .alert("End Game", isPresented: $showEndGameAlert) {
                Button("Confirm", role: .destructive) {
                    viewModel.saveGameRecord()
                    showingEndGameScreen = true
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to end the game?")
            }
            .fullScreenCover(isPresented: $showingEndGameScreen) {
                EndGameView(viewModel: viewModel, selectedTab: $selectedTab) {
                    // Dismiss both the game summary and the end game screen
                    showingEndGameScreen = false
                    presentationMode.wrappedValue.dismiss()
                }
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
                Image(systemName: "arrow.backward").foregroundColor(.white)
            }
            Spacer()
            Text("Game Board Summary").font(.headline).foregroundColor(.white)
            Spacer()
            Rectangle().fill(Color.clear).frame(width: 24)
        }
        .padding()
    }
}

private struct CapsuleButton: View {
    let label: String
    var icon: String? = nil
    var isSelected: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon { Image(systemName: icon) }
                Text(label)
            }
            .padding(.horizontal).padding(.vertical, 10)
            .background(isSelected ? Color.primary : Color.neutralDarkCharcoal)
            .foregroundColor(isSelected ? .backgroundDark : .white)
            .cornerRadius(20)
        }
    }
}

private struct BottomNavBar: View {
    var onSave: () -> Void
    var onEndGame: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Button(action: onSave) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("Save & Exit")
                    }
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.primary).foregroundColor(.backgroundDark)
                    .cornerRadius(30)
                }
                Button(action: onEndGame) {
                    HStack {
                        Image(systemName: "flag")
                        Text("End Game")
                    }
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.monopolyRed).foregroundColor(.white)
                    .cornerRadius(30)
                }
            }
            .padding()
            .background(Color.backgroundDark.opacity(0.8))
        }
    }
}

// MARK: - Previews

struct GameBoardSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let modelContainer = try! ModelContainer(for: GameRecord.self, PlayerProfile.self, PropertySet.self)
        let game = Game.sampleGame
        let viewModel = GameViewModel(game: game, modelContext: modelContainer.mainContext)
        GameBoardSummaryView(viewModel: viewModel, selectedTab: .constant("New Game"))
            .modelContainer(modelContainer)
    }
}
