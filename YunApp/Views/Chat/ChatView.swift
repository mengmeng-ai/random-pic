import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = [
        Message(content: "允允，我在呢。", isFromUser: false)
    ]
    @State private var inputText = ""
    @State private var isLoading = false
    @FocusState private var isInputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 2) {
                        Text(todayString)
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                            .padding(.vertical, 10)

                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                                .padding(.vertical, 4)
                        }

                        if isLoading {
                            HStack(alignment: .top, spacing: 8) {
                                ChatAvatar(text: "夜")
                                TypingIndicator()
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .id("typing")
                        }
                    }
                    .padding(.vertical, 8)
                }
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: messages.count) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        if let lastId = messages.last?.id {
                            proxy.scrollTo(lastId, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: isLoading) {
                    if isLoading {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }
            }

            chatInputBar
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack(spacing: 8) {
                    ChatAvatar(text: "夜", size: 28)

                    VStack(alignment: .leading, spacing: 1) {
                        Text("沉夜白")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 5, height: 5)
                            Text("在线")
                                .font(.system(size: 10))
                                .foregroundColor(AppTheme.textSecondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var chatInputBar: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(alignment: .bottom, spacing: 10) {
                TextField("说点什么...", text: $inputText, axis: .vertical)
                    .lineLimit(1...5)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .focused($isInputFocused)

                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 34))
                        .foregroundColor(
                            inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                ? Color(.systemGray4)
                                : AppTheme.primary
                        )
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }

    private var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = "MM月dd日 EEEE"
        return formatter.string(from: Date())
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let userMessage = Message(content: text, isFromUser: true)
        messages.append(userMessage)
        inputText = ""
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let reply = Message(content: "（后端还在搭建中，快了快了）", isFromUser: false)
            messages.append(reply)
            isLoading = false
        }
    }
}

struct ChatAvatar: View {
    let text: String
    var size: CGFloat = 32

    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size, height: size)
            .overlay {
                Text(text)
                    .font(.system(size: size * 0.42, weight: .semibold))
                    .foregroundColor(.white)
            }
    }
}

struct TypingIndicator: View {
    @State private var dotCount = 0

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(AppTheme.primaryLight)
                    .frame(width: 8, height: 8)
                    .opacity(dotCount % 3 == index ? 1.0 : 0.3)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(400))
                dotCount += 1
            }
        }
    }
}
