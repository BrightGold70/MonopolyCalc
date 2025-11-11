import SwiftUI

struct SortView: View {
    @Binding var sortOrder: GameBoardSummaryView.SortOrder

    var body: some View {
        NavigationView {
            Form {
                Picker("Sort by", selection: $sortOrder) {
                    Text("Name").tag(GameBoardSummaryView.SortOrder.name)
                    Text("Value").tag(GameBoardSummaryView.SortOrder.value)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .navigationTitle("Sort Properties")
        }
    }
}
