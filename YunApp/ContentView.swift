import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ChatView()
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right")
                    Text("聊天")
                }
                .tag(0)

            DiaryView()
                .tabItem {
                    Image(systemName: "book")
                    Text("日记")
                }
                .tag(1)

            CalendarTabView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("日历")
                }
                .tag(2)

            TodoView()
                .tabItem {
                    Image(systemName: "checklist")
                    Text("待办")
                }
                .tag(3)

            TimelineView()
                .tabItem {
                    Image(systemName: "clock.arrow.circlepath")
                    Text("时间轴")
                }
                .tag(4)
        }
        .tint(AppTheme.primary)
    }
}
