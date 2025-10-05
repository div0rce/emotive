//
//  RootTabView.swift
//  Emotive
//
//  Created by moustafa on 10/4/25.
//

import SwiftUI

struct RootTabView: View {
    @State private var selectedTab: Tab = .log  // start on Log tab

    var body: some View {
        TabView(selection: $selectedTab) {
            // --- Tab 1: Log ---
            LogView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Log")
                }
                .accessibilityLabel("Log Mood")
                .tag(Tab.log)

            // --- Tab 2: Feed ---
            FeedView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Feed")
                }
                .accessibilityLabel("Recent Entries")
                .tag(Tab.feed)

            // --- Tab 3: Charts ---
            ChartsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Charts")
                }
                .accessibilityLabel("Mood Charts")
                .tag(Tab.charts)

            // --- Tab 4: Settings ---
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .accessibilityLabel("Settings")
                .tag(Tab.settings)
        }
    }
}

#Preview {
    RootTabView()
}
