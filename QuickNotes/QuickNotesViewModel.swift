import Foundation
import SwiftData

@Observable
class QuickNotesViewModel: NSObject {
    var notes: [DailyNote] = []
    var todayNote: DailyNote?

    func loadNotes(from context: ModelContext) {
        do {
            let descriptor = FetchDescriptor<DailyNote>(sortBy: [SortDescriptor(\.date, order: .reverse)])
            self.notes = try context.fetch(descriptor)
            self.todayNote = notes.first(where: { $0.isToday })
        } catch {
            print("Failed to fetch notes: \(error)")
        }
    }

    func saveOrCreateTodayNote(text: String, with context: ModelContext) {
        if let existing = todayNote {
            existing.text = text
        } else {
            let newNote = DailyNote(date: .now, text: text)
            context.insert(newNote)
            self.todayNote = newNote
        }
        try? context.save()
        loadNotes(from: context)
    }

    func deleteNote(_ note: DailyNote, with context: ModelContext) {
        context.delete(note)
        try? context.save()
        loadNotes(from: context)
    }

    func recentNotes() -> [DailyNote] {
        Array(notes.prefix(7))
    }
}
