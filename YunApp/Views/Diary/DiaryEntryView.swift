import SwiftUI

struct DiaryEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var selectedMood = "📝"
    let onSave: (DiaryEntry) -> Void

    private let moods = ["📝", "😊", "😢", "😡", "🥰", "😴", "🤔", "✨", "💜"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("心情")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                            ForEach(moods, id: \.self) { mood in
                                Text(mood)
                                    .font(.title2)
                                    .frame(width: 44, height: 44)
                                    .background(selectedMood == mood ? AppTheme.primaryLight.opacity(0.3) : Color.clear)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .onTapGesture {
                                        selectedMood = mood
                                    }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("标题")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)

                        TextField("今天的标题", text: $title)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("内容")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)

                        TextEditor(text: $content)
                            .frame(minHeight: 200)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .scrollContentBackground(.hidden)
                    }
                }
                .padding(AppTheme.padding)
            }
            .navigationTitle("写日记")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.textSecondary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        let entry = DiaryEntry(
                            title: title,
                            content: content,
                            author: .yunyun,
                            mood: selectedMood
                        )
                        onSave(entry)
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primary)
                    .fontWeight(.semibold)
                    .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }
}
