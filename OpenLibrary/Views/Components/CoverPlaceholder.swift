import SwiftUI

struct CoverPlaceholder: View {
    var width: CGFloat
    var height: CGFloat
    var circle: CGFloat = 30

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(.secondarySystemBackground))

            GeometryReader { g in
                Path { p in
                    let w = g.size.width, h = g.size.height
                    let c = CGPoint(x: w / 2, y: h / 2)
                    for corner in [CGPoint(x: 0, y: 0), CGPoint(x: w, y: 0),
                                   CGPoint(x: 0, y: h), CGPoint(x: w, y: h)] {
                        p.move(to: corner)
                        p.addLine(to: c)
                    }
                }
                .stroke(Color(.systemGray5), lineWidth: 0.8)
            }

            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(style: StrokeStyle(lineWidth: 0.8, dash: [3]))
                .foregroundStyle(Color(.systemGray3))

            Circle()
                .fill(Color(.systemBackground))
                .frame(width: circle, height: circle)
            Image(systemName: "book.closed")
                .font(.system(size: circle * 0.42))
                .foregroundStyle(.secondary)
        }
        .frame(width: width, height: height)
    }
}
