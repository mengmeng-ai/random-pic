import SwiftUI

struct DiaryView: View {
    @State private var entries: [DiaryEntry] = []
    @State private var showingNewEntry = false
    @State private var selectedAuthorFilter: DiaryAuthor? = nil

    var filteredEntries: [DiaryEntry] {
        if let filter = selectedAuthorFilter {
            return entries.filter { $0.author == filter }
        }
        return entries
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("筛选", selection: $selectedAuthorFilter) {
                    Text("全部").tag(nil as DiaryAuthor?)
                    Text("允允").tag(DiaryAuthor.yunyun as DiaryAuthor?)
                    Text("夜白").tag(DiaryAuthor.chenyebai as DiaryAuthor?)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, AppTheme.padding)
                .padding(.vertical, AppTheme.smallPadding)

                if filteredEntries.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "book.closed")
                            .font(.system(size: 48))
                            .foregroundColor(AppTheme.primaryLight)
                        Text("还没有日记")
                            .foregroundColor(AppTheme.textSecondary)
                        Text("写下今天的心情吧")
                            .font(.caption)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(filteredEntries.sorted(by: { $0.createdAt > $1.createdAt })) { entry in
                            DiaryEntryCard(entry: entry)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                        .onDelete { indexSet in
                            let sorted = filteredEntries.sorted(by: { $0.createdAt > $1.createdAt })
                            for index in indexSet {
                                if let realIndex = entries.firstIndex(where: { $0.id == sorted[index].id }) {
                                    entries.remove(at: realIndex)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("日记")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewEntry = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(AppTheme.primary)
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                DiaryEntryView { entry in
                    entries.append(entry)
                }
            }
        }
    }
}

struct DiaryEntryCard: View {
    let entry: DiaryEntry

    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH:mm"
        return formatter.string(from: entry.createdAt)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.mood ?? "📝")
                    .font(.title3)

                Text(entry.title)
                    .font(.headline)
                    .foregroundColor(AppTheme.textPrimary)

                Spacer()

                Text(entry.author.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(entry.author == .yunyun ? AppTheme.primaryLight.opacity(0.3) : AppTheme.primary.opacity(0.15))
                    .clipShape(Capsule())
                    .foregroundColor(AppTheme.primary)
            }

            Text(entry.content)
                .font(.subheadline)
                .foregroundColor(AppTheme.textSecondary)
                .lineLimit(3)

            Text(dateString)
                .font(.caption2)
                .foregroundColor(AppTheme.textSecondary)
        }
        .padding(14)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}
