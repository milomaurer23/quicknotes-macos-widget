# QuickNotes — macOS Menu Bar Reflection Widget

Daily reflection notes that live in your menu bar. Punch out, quick notes about what you accomplished, and track the past week's reflections.

## Features

- **Today's reflection** — Text editor for daily thoughts/wins
- **Past 7 days** — Quick-scroll through recent reflections
- **One-click save** — Save to local database instantly
- **Delete notes** — Click ✕, then confirm with "Delete"

## Build & Run

Requires macOS 14 (Sonoma) or later.

1. Open `QuickNotes.xcodeproj`
2. Cmd+R to build & run
3. Menu bar icon appears (notepad symbol)

## Use Case

Perfect companion to **Timekeeper**:
1. Punch out from work (Timekeeper)
2. Click notes widget
3. Type what you accomplished (QuickNotes)
4. Done — both logged for the day

## Data

Notes are stored with SwiftData's default configuration in `~/Library/Application Support/default.store` (plus `default.store-shm` / `default.store-wal`). The app isn't sandboxed, so this is the shared Application Support folder, not an app-specific one.
