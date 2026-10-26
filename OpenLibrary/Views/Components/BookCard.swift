import SwiftUI

struct BookCard: View {
    let book: Book

    var body: some View {
        HStack(spacing: 14) {
            CoverPlaceholder(width: 56, height: 56, circle: 24)

            VStack(alignment: .leading, spacing: 3) {
                Text(book.title)
                    .font(.subheadline.weight(.bold))
                    .multilineTextAlignment(.leading)
                Text(book.author)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                if let year = book.year {
                    Text(String(year))
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.systemGray5), lineWidth: 1))
    }
}
