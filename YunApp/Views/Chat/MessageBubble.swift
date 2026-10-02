import SwiftUI

struct MessageBubble: View {
    let message: Message

    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: message.timestamp)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromUser {
                Spacer(minLength: 48)
                VStack(alignment: .trailing, spacing: 3) {
                    Text(message.content)
                        .font(.body)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(AppTheme.primary)
                        .foregroundColor(.white)
                        .clipShape(BubbleShape(isFromUser: true))

                    Text(timeString)
                        .font(.system(size: 10))
                        .foregroundColor(AppTheme.textSecondary)
                        .padding(.trailing, 4)
                }
            } else {
                ChatAvatar(text: "夜")

                VStack(alignment: .leading, spacing: 3) {
                    Text(message.content)
                        .font(.body)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(BubbleShape(isFromUser: false))

                    Text(timeString)
                        .font(.system(size: 10))
                        .foregroundColor(AppTheme.textSecondary)
                        .padding(.leading, 4)
                }
                Spacer(minLength: 48)
            }
        }
        .padding(.horizontal, 12)
    }
}

struct BubbleShape: Shape {
    let isFromUser: Bool

    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 18
        let smallRadius: CGFloat = 4

        return Path { path in
            if isFromUser {
                path.addRoundedRect(
                    in: rect,
                    cornerRadii: .init(
                        topLeading: radius,
                        bottomLeading: radius,
                        bottomTrailing: smallRadius,
                        topTrailing: radius
                    )
                )
            } else {
                path.addRoundedRect(
                    in: rect,
                    cornerRadii: .init(
                        topLeading: radius,
                        bottomLeading: smallRadius,
                        bottomTrailing: radius,
                        topTrailing: radius
                    )
                )
            }
        }
    }
}
