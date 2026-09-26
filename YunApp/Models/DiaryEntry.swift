import Foundation

struct DiaryEntry: Identifiable, Codable {
    let id: UUID
    var title: String
    var content: String
    let author: DiaryAuthor
    let createdAt: Date
    var updatedAt: Date
    var mood: String?

    init(id: UUID = UUID(), title: String, content: String, author: DiaryAuthor, createdAt: Date = Date(), mood: String? = nil) {
        self.id = id
        self.title = title
        self.content = content
        self.author = author
        self.createdAt = createdAt
        self.updatedAt = createdAt
        self.mood = mood
    }
}

enum DiaryAuthor: String, Codable {
    case yunyun = "允允"
    case chenyebai = "沉夜白"
}
