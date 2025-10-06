//
//  EmotiveApp.swift
//  Emotive
//
//  Created by moustafa on 10/1/25.
//

import SwiftUI
import CoreData

@main
struct EmotiveApp: App {
    // Create an observable instance of the Core Data stack.
    private let persistenceController = PersistenceController.shared
    
    @AppStorage("hasSeenOnboarding") var hasSeenOnboarding = false
    @AppStorage("selectedTheme") private var selectedThemeRaw: String = "auto" // "auto" | "light" | "dark"
    
    private var colorSchemePreference: ColorScheme? {
        switch selectedThemeRaw {
        case "light": return .light
        case "dark":  return .dark
        default:      return nil     // auto: follow system
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if (hasSeenOnboarding == false) {
                    OnboardingView()
                }
                else {
                    RootTabView()
                }
            }
            
            .environment(\.managedObjectContext,
                          persistenceController.container.viewContext)
            .preferredColorScheme(colorSchemePreference)
        }
    }
}
