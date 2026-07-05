import Foundation
import SwiftData

@Model
final class DailyNote {
    var id: UUID
    var date: Date
    var text: String
    var createdAt: Date

    init(date: Date, text: String) {
        self.id = UUID()
        self.date = date
        self.text = text
        self.createdAt = .now
    }

    var dateFormatted: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
}
