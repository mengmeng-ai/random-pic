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
                Spacer(minLength: 60)
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(AppTheme.messageSent)
                        .foregroundColor(.white)
                        .clipShape(BubbleShape(isFromUser: true))

                    Text(timeString)
                        .font(.caption2)
                        .foregroundColor(AppTheme.textSecondary)
                }
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.content)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(AppTheme.messageReceived)
                        .foregroundColor(AppTheme.textPrimary)
                        .clipShape(BubbleShape(isFromUser: false))

                    Text(timeString)
                        .font(.caption2)
                        .foregroundColor(AppTheme.textSecondary)
                }
                Spacer(minLength: 60)
            }
        }
        .padding(.horizontal, AppTheme.padding)
    }
}

struct BubbleShape: Shape {
    let isFromUser: Bool

    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 16
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
