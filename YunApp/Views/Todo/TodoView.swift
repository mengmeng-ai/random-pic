import SwiftUI

struct TodoView: View {
    @State private var todos: [TodoItem] = []
    @State private var newTodoTitle = ""
    @FocusState private var isInputFocused: Bool

    var pendingTodos: [TodoItem] {
        todos.filter { !$0.isCompleted }.sorted(by: { $0.createdAt > $1.createdAt })
    }

    var completedTodos: [TodoItem] {
        todos.filter { $0.isCompleted }.sorted(by: { ($0.completedAt ?? $0.createdAt) > ($1.completedAt ?? $1.createdAt) })
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    if !pendingTodos.isEmpty {
                        Section {
                            ForEach(pendingTodos) { todo in
                                TodoRow(todo: todo) {
                                    toggleTodo(todo)
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    if let realIndex = todos.firstIndex(where: { $0.id == pendingTodos[index].id }) {
                                        todos.remove(at: realIndex)
                                    }
                                }
                            }
                        } header: {
                            Text("待完成 (\(pendingTodos.count))")
                        }
                    }

                    if !completedTodos.isEmpty {
                        Section {
                            ForEach(completedTodos) { todo in
                                TodoRow(todo: todo) {
                                    toggleTodo(todo)
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    if let realIndex = todos.firstIndex(where: { $0.id == completedTodos[index].id }) {
                                        todos.remove(at: realIndex)
                                    }
                                }
                            }
                        } header: {
                            Text("已完成 (\(completedTodos.count))")
                        }
                    }

                    if todos.isEmpty {
                        Section {
                            VStack(spacing: 12) {
                                Image(systemName: "checkmark.circle")
                                    .font(.system(size: 48))
                                    .foregroundColor(AppTheme.primaryLight)
                                Text("没有待办事项")
                                    .foregroundColor(AppTheme.textSecondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 40)
                            .listRowBackground(Color.clear)
                        }
                    }
                }
                .listStyle(.insetGrouped)

                Divider()

                HStack(spacing: 12) {
                    TextField("添加待办...", text: $newTodoTitle)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .focused($isInputFocused)
                        .onSubmit {
                            addTodo()
                        }

                    Button {
                        addTodo()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 32))
                            .foregroundColor(newTodoTitle.isEmpty ? AppTheme.textSecondary : AppTheme.primary)
                    }
                    .disabled(newTodoTitle.isEmpty)
                }
                .padding(.horizontal, AppTheme.padding)
                .padding(.vertical, 10)
            }
            .navigationTitle("待办")
        }
    }

    private func addTodo() {
        let title = newTodoTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        let todo = TodoItem(title: title)
        todos.append(todo)
        newTodoTitle = ""
    }

    private func toggleTodo(_ todo: TodoItem) {
        if let index = todos.firstIndex(where: { $0.id == todo.id }) {
            todos[index].isCompleted.toggle()
            if todos[index].isCompleted {
                todos[index].completedAt = Date()
            } else {
                todos[index].completedAt = nil
            }
        }
    }
}

struct TodoRow: View {
    let todo: TodoItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    onToggle()
                }
            } label: {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundColor(todo.isCompleted ? AppTheme.primary : AppTheme.textSecondary)
            }
            .buttonStyle(.plain)

            Text(todo.title)
                .strikethrough(todo.isCompleted)
                .foregroundColor(todo.isCompleted ? AppTheme.textSecondary : AppTheme.textPrimary)

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
