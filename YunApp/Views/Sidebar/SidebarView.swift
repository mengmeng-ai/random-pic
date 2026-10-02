import SwiftUI

struct SidebarView: View {
    @Binding var selected: AppSection
    var onSelect: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [AppTheme.primary, AppTheme.primaryDark],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 38, height: 38)
                    .overlay {
                        Text("♡")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }

                VStack(alignment: .leading, spacing: 2) {
                    Text("允允 & 夜白")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text("我们的小世界")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            Divider()

            ScrollView {
                VStack(spacing: 4) {
                    ForEach(AppSection.allCases, id: \.self) { section in
                        Button {
                            selected = section
                            onSelect?()
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: section.icon)
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(width: 24)

                                Text(section.title)
                                    .font(.subheadline)
                                    .fontWeight(selected == section ? .semibold : .regular)

                                Spacer()
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(
                                selected == section
                                    ? AppTheme.primary.opacity(0.12)
                                    : Color.clear
                            )
                            .foregroundColor(
                                selected == section
                                    ? AppTheme.primary
                                    : AppTheme.textSecondary
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(10)
            }

            Divider()

            HStack(spacing: 10) {
                ChatAvatar(text: "允", size: 32)

                VStack(alignment: .leading, spacing: 1) {
                    Text("允允")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                        Text("在线")
                            .font(.caption2)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                }

                Spacer()

                Image(systemName: "gearshape")
                    .font(.system(size: 14))
                    .foregroundColor(AppTheme.textSecondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
        }
    }
}
