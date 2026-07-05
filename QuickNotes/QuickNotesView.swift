import SwiftUI
import SwiftData

struct QuickNotesView: View {
    @EnvironmentObject var viewModel: QuickNotesViewModel
    @Environment(\.modelContext) var modelContext
    @State private var loaded = false
    @State private var draftText: String = ""

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
                if !draftText.trimmingCharacters(in: .whitespaces).isEmpty {
                    viewModel.saveOrCreateTodayNote(text: draftText, with: modelContext)
                    draftText = ""
                }
            }) {
                Text("Save Reflection")
                    .frame(maxWidth: .infinity)
                    .padding(8)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(4)
            }
            .buttonStyle(.plain)

            Divider()

            // Recent notes
            Text("Past 7 Days")
                .font(.caption)
                .fontWeight(.semibold)

            if viewModel.recentNotes().isEmpty {
                Text("No notes yet")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } else {
                VStack(spacing: 8) {
                    ForEach(viewModel.recentNotes(), id: \.id) { note in
                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(note.dateFormatted)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                Spacer()
                                Button(action: {
                                    viewModel.deleteNote(note, with: modelContext)
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.plain)
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
            if !loaded {
                viewModel.loadNotes(from: modelContext)
                if let today = viewModel.todayNote {
                    draftText = today.text
                }
                loaded = true
            }
        }
    }
}

#Preview {
    QuickNotesView()
        .environmentObject(QuickNotesViewModel())
}
