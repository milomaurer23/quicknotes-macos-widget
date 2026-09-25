import Foundation
import SwiftData

@MainActor
@Observable
class QuickNotesViewModel {
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
        // todayNote goes stale if the app stays open past midnight; never write into a previous day's note.
        if let existing = todayNote, existing.isToday {
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

    /// Notes from the 7 days before today. Today's note lives in the editor.
    var recentNotes: [DailyNote] {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: .now)
        guard let cutoff = calendar.date(byAdding: .day, value: -7, to: startOfToday) else { return [] }
        return notes.filter { $0.date >= cutoff && $0.date < startOfToday }
    }
}
