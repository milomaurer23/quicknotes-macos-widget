import SwiftUI
import SwiftData

struct QuickNotesView: View {
    @Environment(QuickNotesViewModel.self) var viewModel
    @Environment(\.modelContext) var modelContext
    @State private var draftText: String = ""
    /// The day draftText was loaded for, so a reopen keeps unsaved typing but a new day starts fresh.
    @State private var draftDay: Date?
    /// Note whose ✕ was tapped once; a second tap on "Delete" confirms. Kept inline because
    /// alerts presented from a MenuBarExtra window can dismiss the window itself.
    @State private var pendingDeleteID: UUID?

    private var canSave: Bool {
        !draftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && draftText != viewModel.todayNote?.text
    }

    private var isSaved: Bool {
        !draftText.isEmpty && draftText == viewModel.todayNote?.text
    }

    var body: some View {
        VStack(spacing: 12) {
            // Title
            Text("Today's Reflection")
                .font(.headline)

            // Text editor
            TextEditor(text: $draftText)
                .frame(height: 120)
                .border(Color.gray.opacity(0.3))
                .cornerRadius(4)
                .font(.caption)

            // Save button
            Button(action: {
                guard canSave else { return }
                viewModel.saveOrCreateTodayNote(text: draftText, with: modelContext)
                draftDay = Calendar.current.startOfDay(for: .now)
            }) {
                Text(isSaved ? "Saved" : "Save Reflection")
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(canSave ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
            .buttonStyle(.plain)
            .disabled(!canSave)

            Divider()

            // Recent notes
            Text("Past 7 Days")
                .font(.caption)
                .fontWeight(.semibold)

            if viewModel.recentNotes.isEmpty {
                Text("No notes in the past 7 days")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.recentNotes, id: \.id) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(note.dateFormatted)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Spacer()
                                if pendingDeleteID == note.id {
                                    Button("Cancel") {
                                        pendingDeleteID = nil
                                    }
                                    .font(.caption)
                                    .buttonStyle(.plain)
                                    .foregroundColor(.secondary)
                                    Button("Delete") {
                                        pendingDeleteID = nil
                                        viewModel.deleteNote(note, with: modelContext)
                                    }
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .buttonStyle(.plain)
                                    .foregroundColor(.red)
                                } else {
                                    Button(action: {
                                        pendingDeleteID = note.id
                                    }) {
                                        Image(systemName: "xmark")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            Text(note.text)
                                .font(.caption2)
                                .lineLimit(2)
                                .foregroundColor(.secondary)
                        }
                        .padding(8)
                        .background(Color(.controlBackgroundColor))
                        .cornerRadius(4)
                    }
                }
            }
        }
        .padding(12)
        .frame(width: 300)
        .onAppear {
            pendingDeleteID = nil
            viewModel.loadNotes(from: modelContext)
            let today = Calendar.current.startOfDay(for: .now)
            if draftDay != today {
                draftText = viewModel.todayNote?.text ?? ""
                draftDay = today
            }
        }
    }
}

#Preview {
    QuickNotesView()
        .environment(QuickNotesViewModel())
        .modelContainer(for: DailyNote.self, inMemory: true)
}
