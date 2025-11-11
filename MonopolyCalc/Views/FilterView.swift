import SwiftUI

struct FilterView: View {
    @Binding var selectedFilter: GameBoardSummaryView.FilterType
    @Binding var selectedGroup: PropertyGroup?

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
                    ForEach(PropertyGroup.allCases) { group in
                        Text(group.rawValue.capitalized).tag(group as PropertyGroup?)
                    }
                }
            }
            .navigationTitle("Filter Properties")
        }
    }
}
