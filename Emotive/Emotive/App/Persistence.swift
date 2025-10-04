//
//  Persistence.swift
//  Emotive
//

import CoreData

struct PersistenceController {
    // Shared singleton instance for app-wide use
    static let shared = PersistenceController()

    // Preview instance for SwiftUI previews (uses in-memory store)
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        // Create some sample MoodEntry data here if you like
        return controller
    }()

    // The persistent container that loads the Core Data stack
    let container: NSPersistentContainer

    // Initializer
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Emotive")
        // ^ must exactly match your .xcdatamodeld file name

        if inMemory {
            // Store only in RAM (useful for previews)
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
#if DEBUG
            print("[DEBUG] Core Data store loaded at:", storeDescription.url?.absoluteString ?? "nil")
#endif
            if let error = error as NSError? {
                // Replace this with proper error handling in production
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        // Merge policy ensures “last write wins” to avoid common save conflicts
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}
