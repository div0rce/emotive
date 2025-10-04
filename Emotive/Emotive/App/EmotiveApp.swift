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
        }
    }
}
