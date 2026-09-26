import SwiftUI

struct CalendarTabView: View {
    @State private var events: [CalendarEvent] = [
        CalendarEvent(title: "允允生日", date: makeDate(month: 2, day: 9), isAnniversary: true, emoji: "🎂")
    ]
    @State private var selectedDate = Date()
    @State private var showingAddEvent = false

    var eventsForSelectedDate: [CalendarEvent] {
        events.filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
    }

    var upcomingAnniversaries: [CalendarEvent] {
        let now = Date()
        return events.filter { $0.isAnniversary }.sorted { event1, event2 in
            nextOccurrence(of: event1.date, after: now) < nextOccurrence(of: event2.date, after: now)
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    DatePicker("选择日期", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .tint(AppTheme.primary)
                        .padding(.horizontal, AppTheme.padding)

                    if !upcomingAnniversaries.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("纪念日")
                                .font(.headline)
                                .padding(.horizontal, AppTheme.padding)

                            ForEach(upcomingAnniversaries) { event in
                                HStack(spacing: 12) {
                                    Text(event.emoji ?? "💜")
                                        .font(.title2)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(event.title)
                                            .font(.subheadline)
                                            .fontWeight(.medium)

                                        Text(daysUntil(event.date))
                                            .font(.caption)
                                            .foregroundColor(AppTheme.textSecondary)
                                    }

                                    Spacer()
                                }
                                .padding(12)
                                .background(AppTheme.primaryLight.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal, AppTheme.padding)
                            }
                        }
                    }

                    if !eventsForSelectedDate.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("当日事件")
                                .font(.headline)
                                .padding(.horizontal, AppTheme.padding)

                            ForEach(eventsForSelectedDate) { event in
                                HStack(spacing: 12) {
                                    Text(event.emoji ?? "📌")
                                        .font(.title3)

                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(event.title)
                                            .font(.subheadline)
                                            .fontWeight(.medium)

                                        if !event.note.isEmpty {
                                            Text(event.note)
                                                .font(.caption)
                                                .foregroundColor(AppTheme.textSecondary)
                                        }
                                    }

                                    Spacer()
                                }
                                .padding(12)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .padding(.horizontal, AppTheme.padding)
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("日历")
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
                AddEventView(selectedDate: selectedDate) { event in
                    events.append(event)
                }
            }
        }
    }

    private func daysUntil(_ date: Date) -> String {
        let now = Date()
        let next = nextOccurrence(of: date, after: now)
        let days = Calendar.current.dateComponents([.day], from: now, to: next).day ?? 0
        if days == 0 {
            return "就是今天!"
        }
        return "还有 \(days) 天"
    }

    private func nextOccurrence(of date: Date, after: Date) -> Date {
        let cal = Calendar.current
        var components = cal.dateComponents([.month, .day], from: date)
        components.year = cal.component(.year, from: after)
        if let thisYear = cal.date(from: components), thisYear >= after {
            return thisYear
        }
        components.year = cal.component(.year, from: after) + 1
        return cal.date(from: components) ?? after
    }
}

private func makeDate(month: Int, day: Int) -> Date {
    var components = DateComponents()
    components.year = 2026
    components.month = month
    components.day = day
    return Calendar.current.date(from: components) ?? Date()
}

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    let selectedDate: Date
    let onSave: (CalendarEvent) -> Void

    @State private var title = ""
    @State private var note = ""
    @State private var date: Date
    @State private var isAnniversary = false
    @State private var emoji = "💜"

    private let emojis = ["💜", "🎂", "❤️", "🎉", "✨", "🌙", "🔥", "📌"]

    init(selectedDate: Date, onSave: @escaping (CalendarEvent) -> Void) {
        self.selectedDate = selectedDate
        self.onSave = onSave
        _date = State(initialValue: selectedDate)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("事件名称", text: $title)
                    TextField("备注", text: $note)
                }

                Section {
                    DatePicker("日期", selection: $date, displayedComponents: .date)
                    Toggle("设为纪念日", isOn: $isAnniversary)
                        .tint(AppTheme.primary)
                }

                Section("图标") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
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
            .navigationTitle("添加事件")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                        .foregroundColor(AppTheme.textSecondary)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        let event = CalendarEvent(
                            title: title,
                            note: note,
                            date: date,
                            isAnniversary: isAnniversary,
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
