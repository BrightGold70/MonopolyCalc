import SwiftUI

struct ConfettiView: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate

                for i in 0..<30 {
                    let x = (sin(Double(i) * 2.3 + time * 1.2) * 0.4 + 0.5) * size.width
                    let y = fmod(time * 0.5 * Double(i % 5 + 1), size.height * 1.2) - 0.1 * size.height

                    let colors: [Color] = [.primary, .accent, .yellow]
                    context.fill(Path(ellipseIn: CGRect(x: x, y: y, width: 10, height: 10)), with: .color(colors[i % colors.count]))
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct ConfettiView_Previews: PreviewProvider {
    static var previews: some View {
        ConfettiView()
            .background(Color.backgroundDark)
    }
}
