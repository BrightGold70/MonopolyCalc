import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ScoreViewModel()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Money")) {
                    TextField("Enter cash amount", text: $viewModel.cash)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Properties")) {
                    TextField("Enter total value of properties", text: $viewModel.properties)
                        .keyboardType(.numberPad)
                }

                Section(header: Text("Buildings")) {
                    Stepper(value: $viewModel.houses, in: 0...100) {
                        Text("Houses: \(viewModel.houses)")
                    }
                    Stepper(value: $viewModel.hotels, in: 0...100) {
                        Text("Hotels: \(viewModel.hotels)")
                    }
                }

                Section(header: Text("Railroads & Utilities")) {
                    Stepper(value: $viewModel.railroads, in: 0...4) {
                        Text("Railroads: \(viewModel.railroads)")
                    }
                    Stepper(value: $viewModel.utilities, in: 0...2) {
                        Text("Utilities: \(viewModel.utilities)")
                    }
                }

                Section(header: Text("Total Score")) {
                    Text(String(viewModel.totalScore))
                        .font(.headline)
                }
            }
            .navigationTitle("Monopoly Scorer")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
