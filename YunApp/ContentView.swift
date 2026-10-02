import SwiftUI

enum AppSection: String, CaseIterable, Hashable {
    case chat, diary, calendar, todo, timeline

    var title: String {
        switch self {
        case .chat: return "聊天"
        case .diary: return "日记"
        case .calendar: return "日历"
        case .todo: return "待办"
        case .timeline: return "时间轴"
        }
    }

    var icon: String {
        switch self {
        case .chat: return "message.fill"
        case .diary: return "book.fill"
        case .calendar: return "calendar"
        case .todo: return "checklist"
        case .timeline: return "clock.arrow.circlepath"
        }
    }
}

struct ContentView: View {
    @State private var selectedSection: AppSection = .chat
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var isCompact: Bool { sizeClass == .compact }

    var body: some View {
        if isCompact {
            tabLayout
        } else {
            sidebarLayout
        }
    }

    private var tabLayout: some View {
        TabView(selection: $selectedSection) {
            ForEach(AppSection.allCases, id: \.self) { section in
                NavigationStack {
                    sectionView(for: section)
                }
                .tabItem {
                    Label(section.title, systemImage: section.icon)
                }
                .tag(section)
            }
        }
        .tint(AppTheme.primary)
    }

    private var sidebarLayout: some View {
        HStack(spacing: 0) {
            SidebarView(selected: $selectedSection)
                .frame(width: 280)

            Rectangle()
                .fill(AppTheme.border)
                .frame(width: 0.5)

            NavigationStack {
                sectionView(for: selectedSection)
            }
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func sectionView(for section: AppSection) -> some View {
        switch section {
        case .chat: ChatView()
        case .diary: DiaryView()
        case .calendar: CalendarTabView()
        case .todo: TodoView()
        case .timeline: TimelineView()
        }
    }
}
