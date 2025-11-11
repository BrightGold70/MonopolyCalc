import SwiftUI

struct BottomNavBarView: View {
    @Binding var isEndGameModalPresented: Bool

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                isEndGameModalPresented = true
            }) {
                Text("End Game")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.monopolyRed)
                    .cornerRadius(25)
            }
            .padding(.horizontal)

            HStack {
                NavBarButton(icon: "plus.circle.fill", label: "Calculator")
                NavBarButton(icon: "map", label: "Board")

                Button(action: {}) {
                    Image(systemName: "plus")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Color.monopolyGreen)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .offset(y: -40)

                NavBarButton(icon: "list.bullet.rectangle", label: "Log")
                NavBarButton(icon: "gear", label: "Settings")
            }
            .padding(.top)
        }
        .padding(.bottom, 20)
        .background(Color.neutralOffWhite.shadow(radius: 2))
    }
}

struct NavBarButton: View {
    let icon: String
    let label: String

    var body: some View {
        Button(action: {}) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(label)
                    .font(.caption)
            }
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity)
        }
    }
}

struct BottomNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavBarView(isEndGameModalPresented: .constant(false))
    }
}
