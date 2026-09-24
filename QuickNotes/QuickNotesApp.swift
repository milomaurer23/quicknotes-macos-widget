import SwiftUI
import SwiftData

@main
struct QuickNotesApp: App {
    @State var viewModel = QuickNotesViewModel()

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
                .environment(viewModel)
                .modelContainer(modelContainer)
        }, label: {
            Image(systemName: "note.text")
        })
        // The default .menu style renders content as menu items, so the TextEditor can't take input.
        .menuBarExtraStyle(.window)
    }
}
