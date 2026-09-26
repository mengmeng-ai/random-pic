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
        case .chat: return "bubble.left.and.bubble.right.fill"
        case .diary: return "book.fill"
        case .calendar: return "calendar"
        case .todo: return "checklist"
        case .timeline: return "clock.arrow.circlepath"
        }
    }
}

struct ContentView: View {
    @State private var selectedSection: AppSection = .chat
    @State private var isSidebarVisible = false
    @Environment(\.horizontalSizeClass) private var sizeClass

    private var isCompact: Bool { sizeClass == .compact }

    var body: some View {
        ZStack(alignment: .leading) {
            HStack(spacing: 0) {
                if !isCompact {
                    SidebarView(selected: $selectedSection)
                        .frame(width: 280)

                    Rectangle()
                        .fill(AppTheme.border)
                        .frame(width: 0.5)
                }

                NavigationStack {
                    detailView
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            if isCompact {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.25)) {
                                            isSidebarVisible.toggle()
                                        }
                                    } label: {
                                        Image(systemName: "sidebar.left")
                                            .foregroundColor(AppTheme.primary)
                                    }
                                }
                            }
                        }
                }
                .frame(maxWidth: .infinity)
            }

            if isCompact && isSidebarVisible {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            isSidebarVisible = false
                        }
                    }
                    .zIndex(10)

                SidebarView(selected: $selectedSection) {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        isSidebarVisible = false
                    }
                }
                .frame(width: 280)
                .background(Color(.systemBackground))
                .shadow(color: .black.opacity(0.15), radius: 12, x: 4)
                .transition(.move(edge: .leading))
                .zIndex(11)
            }
        }
    }

    @ViewBuilder
    private var detailView: some View {
        switch selectedSection {
        case .chat: ChatView()
        case .diary: DiaryView()
        case .calendar: CalendarTabView()
        case .todo: TodoView()
        case .timeline: TimelineView()
        }
    }
}
