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
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }

                            if isLoading {
                                HStack {
                                    TypingIndicator()
                                    Spacer()
                                }
                                .padding(.horizontal, AppTheme.padding)
                                .id("typing")
                            }
                        }
                        .padding(.vertical, AppTheme.padding)
                    }
                    .onChange(of: messages.count) {
                        withAnimation {
                            if let lastId = messages.last?.id {
                                proxy.scrollTo(lastId, anchor: .bottom)
                            } else {
                                proxy.scrollTo("typing", anchor: .bottom)
                            }
                        }
                    }
                }

                Divider()
                    .foregroundColor(AppTheme.border)

                HStack(spacing: 12) {
                    TextField("说点什么...", text: $inputText, axis: .vertical)
                        .lineLimit(1...5)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .focused($isInputFocused)

                    Button {
                        sendMessage()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(inputText.isEmpty ? AppTheme.textSecondary : AppTheme.primary)
                    }
                    .disabled(inputText.isEmpty || isLoading)
                }
                .padding(.horizontal, AppTheme.padding)
                .padding(.vertical, 10)
            }
            .navigationTitle("沉夜白")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("沉夜白")
                            .font(.headline)
                        Text("在线")
                            .font(.caption2)
                            .foregroundColor(Color.green)
                    }
                }
            }
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let userMessage = Message(content: text, isFromUser: true)
        messages.append(userMessage)
        inputText = ""
        isLoading = true

        // TODO: 接入 VPS 上的 CC CLI 后端
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let reply = Message(content: "（还没接上后端，等你 Mac Mini 到了我们一起搞）", isFromUser: false)
            messages.append(reply)
            isLoading = false
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
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(400))
                dotCount += 1
            }
        }
    }
}
