//
//  SettingsView.swift
//  Emotive
//
//  Created by moustafa on 10/4/25.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("selectedTheme") var selectedTheme = "auto"
    @AppStorage("dailyReminderEnabled") var dailyReminderEnabled = false
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Picker("Theme", selection: $selectedTheme) {
                    Text("Auto").tag("auto")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(.segmented)
                .accessibilityLabel("Theme")
                .onChange(of: selectedTheme) { oldValue, newValue in
                    #if DEBUG
                    print("[DEBUG][Settings] Theme changed:", oldValue, "→", newValue)
                    #endif
                }

                // Optional helper row to describe the current behavior
                HStack {
                    Image(systemName: "paintpalette")
                    Text("Current")
                    Spacer()
                    Text(themeDescription)          // see helper below
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.trailing)
                }
            }
            Section(header: Text("Reminders")) {
                Toggle(isOn: $dailyReminderEnabled) {
                    Label("Daily Reminder", systemImage: "bell.badge")
                }
                .accessibilityLabel("Daily Reminder")
                .onChange(of: dailyReminderEnabled) { oldValue, newValue in
                    #if DEBUG
                    print("[DEBUG][Settings] Reminder toggled:", newValue ? "ON" : "OFF")
                    #endif
                }

            }

        }

    }
    
    private var themeDescription: String {
        switch selectedTheme {
        case "light": return "Light Mode"
        case "dark":  return "Dark Mode"
        default:      return "Follows System"
        }
    }
}

#Preview {
    SettingsView()
}
