# Emotive MoodTracker (SwiftUI + Core Data)

A tiny, production-minded mood journal:
- Log mood (emoji + 1–5) with an optional note
- Browse recent entries
- Visualize trends over the last 7–30 days
- Local-first storage; preferences via AppStorage

## Why it exists
Demonstrates state management, local persistence, forms, lists, and charts in SwiftUI — a core stepping stone toward building Flock (social/dating).

## Architecture
- SwiftUI views rendered from observable state
- Core Data for durable records (Entity: MoodEntry)
- AppStorage for small preferences (theme, onboarding)
- Charts for time-series visualization

## Key Learnings
- Core Data modeling, fetches, and saves
- View-driven form validation
- Grouping and aggregating data for charts

## Screens
(Insert screenshots here from /captures)

## Roadmap
- Multiselect emoji palette
- Reminders (local notifications)
- iCloud sync
- Widgets

