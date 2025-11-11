import SwiftUI
import SwiftData

struct FilterView: View {
    @Binding var selectedFilter: GameBoardSummaryView.FilterType
    @Binding var selectedGroup: PropertyGroup?

    @Query private var propertyGroups: [PropertyGroup]

    var body: some View {
        NavigationView {
            Form {
                Picker("Filter by", selection: $selectedFilter) {
                    Text("None").tag(GameBoardSummaryView.FilterType.none)
                    Text("Owned").tag(GameBoardSummaryView.FilterType.owned)
                    Text("Unowned").tag(GameBoardSummaryView.FilterType.unowned)
                    Text("Mortgaged").tag(GameBoardSummaryView.FilterType.mortgaged)
                }
                .pickerStyle(SegmentedPickerStyle())

                Picker("Group", selection: $selectedGroup) {
                    Text("All Groups").tag(nil as PropertyGroup?)
                    ForEach(propertyGroups) { group in
                        Text(group.name.capitalized).tag(group as PropertyGroup?)
                    }
                }
            }
            .navigationTitle("Filter Properties")
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(selectedFilter: .constant(.none), selectedGroup: .constant(nil))
            .modelContainer(for: PropertyGroup.self, inMemory: true)
    }
}
