import SwiftUI
import SwiftData

@main
struct QuickNotesApp: App {
    @StateObject var viewModel = QuickNotesViewModel()

    let modelContainer: ModelContainer

    init() {
        do {
            modelContainer = try ModelContainer(for: DailyNote.self)
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }

    var body: some Scene {
        MenuBarExtra(content: {
            QuickNotesView()
                .environmentObject(viewModel)
                .modelContainer(modelContainer)
        }, label: {
            Image(systemName: "note.text")
        })
    }
}
