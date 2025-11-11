import SwiftUI
import SwiftData

struct GameBoardSummaryView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: GameViewModel
    @State private var searchText = ""
    @State private var showEndGameAlert = false
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
        var properties = viewModel.allPropertiesWithOwnership

        // Filtering
        switch selectedFilter {
        case .owned:
            properties = properties.filter { $0.isOwned }
        case .unowned:
            properties = properties.filter { !$0.isOwned }
        case .mortgaged:
            properties = properties.filter { $0.isMortgaged }
        case .none:
            break
        }

        if let group = selectedGroup {
            properties = properties.filter { $0.group == group }
        }

        // Sorting
        switch sortOrder {
        case .name:
            properties.sort { $0.name < $1.name }
        case .value:
            properties.sort { $0.originalValue > $1.originalValue }
        }

        // Search
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
                    HeaderView()

                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                        TextField("Search for a property or player...", text: $searchText)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.neutralDarkCharcoal)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    // Filter and Sort Buttons
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            CapsuleButton(label: "Filter", icon: "line.3.horizontal.decrease.circle", action: {
                                showingFilterSheet = true
                            })
                            CapsuleButton(label: "Sort", icon: "arrow.up.arrow.down.circle", action: {
                                showingSortSheet = true
                            })
                            CapsuleButton(label: "Owned", isSelected: selectedFilter == .owned, action: {
                                selectedFilter = selectedFilter == .owned ? .none : .owned
                            })
                            CapsuleButton(label: "Unowned", isSelected: selectedFilter == .unowned, action: {
                                selectedFilter = selectedFilter == .unowned ? .none : .unowned
                            })
                            CapsuleButton(label: "Mortgaged", isSelected: selectedFilter == .mortgaged, action: {
                                selectedFilter = selectedFilter == .mortgaged ? .none : .mortgaged
                            })
                        }
                        .padding(.horizontal)
                    }

                    ScrollView {
                        ForEach(groupedProperties.keys.sorted(by: { $0.name < $1.name }), id: \.self) { group in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(group.name.capitalized)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding(.leading)

                                ForEach(groupedProperties[group]!) { property in
                                    NavigationLink(value: property) {
                                        PropertyRowView(property: property)
                                            .padding(.horizontal)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                             }
                            .padding(.vertical)
                        }
                    }
                }

                // Bottom Navigation Bar
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            showingManagePropertySheet = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.pencil")
                                Text("Manage Property")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primary)
                            .foregroundColor(.backgroundDark)
                            .cornerRadius(30)
                        }
                        Button(action: {
                            showEndGameAlert = true
                        }) {
                            HStack {
                                Image(systemName: "flag")
                                Text("End Game")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.monopolyRed)
                            .foregroundColor(.white)
                            .cornerRadius(30)
                        }
                    }
                    .padding()
                    .background(Color.backgroundDark.opacity(0.8))
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: Property.self) { property in
                PropertyDetailView(property: property, viewModel: viewModel)
            }
            .navigationDestination(for: GameViewModel.self) { viewModel in
                EndGameView(winner: viewModel.calculateWinner())
            }
            .sheet(isPresented: $showingManagePropertySheet) {
                ManagePropertyView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingFilterSheet) {
                FilterView(selectedFilter: $selectedFilter, selectedGroup: $selectedGroup)
            }
            .sheet(isPresented: $showingSortSheet) {
                SortView(sortOrder: $sortOrder)
            }
            .alert(isPresented: $showEndGameAlert) {
                Alert(
                    title: Text("End Game"),
                    message: Text("Are you sure you want to end the game?"),
                    primaryButton: .destructive(Text("Confirm")) {
                        viewModel.saveGameRecord()
                        navigationPath.append(viewModel)
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct HeaderView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.backward")
                    .foregroundColor(.white)
            }
            Spacer()
            Text("Game Board Summary")
                .font(.headline)
                .foregroundColor(.white)
            Spacer()
            // Placeholder for right side item
            Rectangle().fill(Color.clear).frame(width: 24)
        }
        .padding()
    }
}

struct CapsuleButton: View {
    let label: String
    var icon: String? = nil
    var isSelected: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(label)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(isSelected ? Color.primary : Color.neutralDarkCharcoal)
            .foregroundColor(isSelected ? .backgroundDark : .white)
            .cornerRadius(20)
        }
    }
}


struct GameBoardSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let modelContainer = try! ModelContainer(for: GameRecord.self, PlayerProfile.self, PropertySet.self)
        let game = Game.sampleGame
        let viewModel = GameViewModel(game: game, modelContext: modelContainer.mainContext)
        GameBoardSummaryView(viewModel: viewModel)
            .modelContainer(modelContainer)
    }
}
