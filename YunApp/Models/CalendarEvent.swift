import Foundation

struct CalendarEvent: Identifiable, Codable {
    let id: UUID
    var title: String
    var note: String
    var date: Date
    var isAnniversary: Bool
    var emoji: String?

    init(id: UUID = UUID(), title: String, note: String = "", date: Date, isAnniversary: Bool = false, emoji: String? = nil) {
        self.id = id
        self.title = title
        self.note = note
        self.date = date
        self.isAnniversary = isAnniversary
        self.emoji = emoji
    }
}
