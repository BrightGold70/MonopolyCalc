import SwiftUI

struct PlayerScoreRowView: View {
    let ranking: PlayerRanking
    let rank: Int
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 16) {
                    Group {
                        if rank == 1 {
                            Image(systemName: "trophy.fill")
                                .foregroundColor(.yellow)
                        } else {
                            Text(rankOrdinal)
                                .fontWeight(.bold)
                        }
                    }
                    .font(.system(size: 24))
                    .frame(width: 40)

                    Text(ranking.name)
                        .font(.lg)

                    Spacer()

                    Text("$\(ranking.netWorth, specifier: "%.2f")")
                        .font(.lg)
                        .fontWeight(.bold)
                        .foregroundColor(rank == 1 ? .primary : .white)
                }
                .padding(.horizontal)
                .frame(minHeight: 56)
            }

            if isExpanded {
                VStack(spacing: 8) {
                    ScoreDetailRow(label: "Cash", value: ranking.cash)
                    ScoreDetailRow(label: "Properties", value: ranking.propertyValue)
                    ScoreDetailRow(label: "Houses & Hotels", value: ranking.buildingValue)
                }
                .padding()
                .background(Color.black.opacity(0.2))
            }
        }
        .background(Color.white.opacity(0.05))
        .cornerRadius(10)
        .foregroundColor(.white.opacity(0.8))
    }

    private var rankOrdinal: String {
        switch rank {
        case 2: return "2nd"
        case 3: return "3rd"
        case 4: return "4th"
        default: return "\(rank)th"
        }
    }
}

private struct ScoreDetailRow: View {
    let label: String
    let value: Double

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text("$\(value, specifier: "%.2f")")
        }
        .font(.sm)
    }
}
