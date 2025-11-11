import SwiftUI

struct FilterView: View {
    @Binding var selectedFilter: GameBoardSummaryView.FilterType
    @Binding var selectedColor: PropertyColor?

    var body: some View {
        NavigationView {
            Form {
                Picker("Filter by", selection: $selectedFilter) {
                    Text("None").tag(GameBoardSummaryView.FilterType.none)
                    Text("Owned").tag(GameBoardSummaryView.FilterType.owned)
                    Text("Unowned").tag(GameBoardSummaryView.FilterType.unowned)
                    Text("Mortgaged").tag(GameBoardSummaryView.FilterType.mortgaged)
                    Text("Monopoly").tag(GameBoardSummaryView.FilterType.monopoly)
                }
                .pickerStyle(SegmentedPickerStyle())

                Picker("Color", selection: $selectedColor) {
                    Text("All Colors").tag(nil as PropertyColor?)
                    ForEach(PropertyColor.allCases) { color in
                        Text(color.rawValue.capitalized).tag(color as PropertyColor?)
                    }
                }
            }
            .navigationTitle("Filter Properties")
        }
    }
}
