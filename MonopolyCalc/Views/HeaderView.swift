import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "square.and.arrow.down")
                    .font(.title)
                    .foregroundColor(.white)
            }

            Spacer()

            Text("Monopoly Scoreboard")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Spacer()

            Button(action: {}) {
                Image(systemName: "dice")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.monopolyGreen)
        .shadow(radius: 5)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
