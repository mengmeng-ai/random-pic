import Foundation

struct Message: Identifiable, Codable {
    let id: UUID
    let content: String
    let isFromUser: Bool
    let timestamp: Date
    var isTyping: Bool = false

    init(id: UUID = UUID(), content: String, isFromUser: Bool, timestamp: Date = Date(), isTyping: Bool = false) {
        self.id = id
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = timestamp
        self.isTyping = isTyping
    }
}
