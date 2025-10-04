# Mood Tracker App Blueprint

## Overview
A small SwiftUI app that allows users to:
- Log their current mood (emoji + 1–5 scale + optional note).
- View recent entries in a feed.
- Visualize average moods over the last 7–30 days in a chart.
- Adjust basic preferences (theme, daily reminders).
- Data is stored locally with Core Data. Settings use AppStorage.

---

## Data Model

### Core Data Entity: `MoodEntry`
- **id**: UUID (non-optional)
- **createdAt**: Date (non-optional, set when saved)
- **moodScore**: Int16 (range: 1–5, non-optional)
- **emoji**: String (single emoji, non-optional)
- **note**: String (optional, up to ~280 chars)

### AppStorage Keys
- `selectedTheme: String` → `"auto" | "light" | "dark"`
- `hasSeenOnboarding: Bool`
- `dailyReminderEnabled: Bool`

---

## Screens

### OnboardingView
- Shown on first launch only (if `hasSeenOnboarding == false`).
- Simple 3–4 screen carousel with app intro.
- Ends with “Get Started” → sets `hasSeenOnboarding = true`.

### RootTabView
Tabbed interface with 4 main sections:
1. **LogView** → Create a new mood entry.
2. **FeedView** → List of all entries (reverse chronological).
3. **ChartsView** → Visualization of mood trends over time.
4. **SettingsView** → Theme + reminders.

---

## Navigation

- **Root**: App starts → Onboarding OR RootTabView.
- **Tabs**:
  - Log → (saves directly into Core Data).
  - Feed → Row tap → EntryDetailView (edit/delete).
  - Charts → No navigation, just chart display.
  - Settings → Standalone.

---

## Features by Screen

### LogView (Create Mood)
- Emoji grid (user must select one).
- Mood slider (1–5, with haptics).
- Optional note text box (multiline).
- Save button (disabled until emoji selected).
- On save:
  - Create new `MoodEntry` in Core Data.
  - Reset form state.
  - Show toast “Saved!”.

### FeedView (Browse Entries)
- Fetch all `MoodEntry` sorted by `createdAt DESC`.
- Each row:
  - Emoji + mood score.
  - Date/time (formatted).
  - Optional note snippet (truncated).
- Swipe to delete.
- Tap row → EntryDetailView (edit/delete).

### EntryDetailView (Edit/Delete)
- Pre-filled form with existing data.
- Save button updates entry in Core Data.
- Delete button removes entry after confirmation.

### ChartsView (Visualize Trends)
- Aggregate entries by calendar day.
- Compute daily average mood.
- Display as line or bar chart (using Charts framework).
- Toggle between 7-day and 30-day windows.
- Empty state message when no data.

### SettingsView
- Theme picker (Auto/Light/Dark) → stored in AppStorage.
- Daily reminder toggle → stored in AppStorage.
- Reset onboarding (optional).

---

## Acceptance Criteria
- User can log, edit, and delete entries.
- Entries persist across app relaunches.
- Feed updates immediately after adding/editing/deleting.
- Charts update dynamically based on entries.
- Preferences persist across app relaunches.
- Onboarding shows only once (unless reset).

---

## Stretch Goals
- Local notifications for daily reminders.
- Export entries to CSV (share sheet).
- iCloud sync (enable Core Data + CloudKit).
- Homescreen widget for quick logging.
- Tags for entries (e.g., “work”, “gym”) and filtered charts.

---

