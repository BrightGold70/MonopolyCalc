import SwiftUI

struct TextFieldAlert<Presenting>: View where Presenting: View {
    @Binding var isShowing: Bool
    let title: String
    let presenting: Presenting
    let onSave: (String) -> Void

    @State private var text = ""

    var body: some View {
        ZStack {
            presenting
                .disabled(isShowing)

            if isShowing {
                VStack {
                    Text(title)
                        .font(.headline)
                        .padding()

                    TextField("Template Name", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    HStack {
                        Button("Cancel") {
                            isShowing = false
                        }

                        Spacer()

                        Button("Save") {
                            onSave(text)
                            isShowing = false
                        }
                    }
                    .padding()
                }
                .frame(width: 300)
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(radius: 40)
            }
        }
    }
}

extension View {
    func textFieldAlert(isShowing: Binding<Bool>, title: String, onSave: @escaping (String) -> Void) -> some View {
        TextFieldAlert(isShowing: isShowing, title: title, presenting: self, onSave: onSave)
    }
}
