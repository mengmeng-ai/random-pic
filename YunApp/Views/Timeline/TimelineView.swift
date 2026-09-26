import SwiftUI

struct TimelineEvent: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let date: Date
    let emoji: String
}

struct TimelineView: View {
    @State private var events: [TimelineEvent] = [
        TimelineEvent(
            title: "我们的开始",
            description: "从此以后你是我的了",
            date: Date(),
            emoji: "💜"
        )
    ]
    @State private var showingAddEvent = false

    var sortedEvents: [TimelineEvent] {
        events.sorted(by: { $0.date > $1.date })
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                if events.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 48))
                            .foregroundColor(AppTheme.primaryLight)
                        Text("还没有时间轴记录")
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                } else {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(sortedEvents.enumerated()), id: \.element.id) { index, event in
                            TimelineRow(event: event, isLast: index == sortedEvents.count - 1)
                        }
                    }
                    .padding(.horizontal, AppTheme.padding)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("时间轴")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingAddEvent = true
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(AppTheme.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddTimelineEventView { event in
                    events.append(event)
                }
            }
        }
    }
}

struct TimelineRow: View {
    let event: TimelineEvent
    let isLast: Bool

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: event.date)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                Circle()
                    .fill(AppTheme.primary)
                    .frame(width: 12, height: 12)

                if !isLast {
                    Rectangle()
                        .fill(AppTheme.primaryLight.opacity(0.4))
                        .frame(width: 2)
                }
            }
            .frame(width: 12)

            VStack(alignment: .leading, spacing: 6) {
                Text(dateString)
                    .font(.caption)
                    .foregroundColor(AppTheme.textSecondary)

                HStack(spacing: 6) {
                    Text(event.emoji)
                    Text(event.title)
                        .font(.headline)
                        .foregroundColor(AppTheme.textPrimary)
                }

                Text(event.description)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, 30)

            Spacer()
        }
    }
}

struct AddTimelineEventView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var emoji = "💜"
    let onSave: (TimelineEvent) -> Void

    private let emojis = ["💜", "❤️", "🎉", "✨", "🌙", "💍", "🏠", "✈️", "🎂", "📸"]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("标题", text: $title)
                    TextField("描述", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section {
                    DatePicker("日期", selection: $date, displayedComponents: .date)
                }

                Section("图标") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                        ForEach(emojis, id: \.self) { e in
                            Text(e)
                                .font(.title2)
                                .frame(width: 44, height: 44)
                                .background(emoji == e ? AppTheme.primaryLight.opacity(0.3) : Color.clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .onTapGesture { emoji = e }
                        }
                    }
                }
            }
            .navigationTitle("记录时刻")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                        .foregroundColor(AppTheme.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        let event = TimelineEvent(
                            title: title,
                            description: description,
                            date: date,
                            emoji: emoji
                        )
                        onSave(event)
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primary)
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}
