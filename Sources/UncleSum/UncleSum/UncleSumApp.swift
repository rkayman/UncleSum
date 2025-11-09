//
//  UncleSumApp.swift
//  UncleSum
//
//  Created by Rob Kayman on 11/5/25.
//

import SwiftUI
import SwiftData

@main
struct UncleSumApp: App {
    @AppStorage("didSeedFacts") private var didSeedFacts = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Fact.self,
            PerformanceRecord.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    performFirstRunSeeding()
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    /// Seeds the database with 100 starter facts on first launch
    /// Uses @AppStorage flag to ensure idempotent seeding
    private func performFirstRunSeeding() {
        guard !didSeedFacts else { return }
        
        let context = sharedModelContainer.mainContext
        let starterFacts = SeedFactory.starterFacts()
        
        // Insert facts into SwiftData
        for fact in starterFacts {
            context.insert(fact)
        }
        
        // Save context
        do {
            try context.save()
            didSeedFacts = true
            print("✓ Seeded \(starterFacts.count) facts on first launch")
        } catch {
            print("Failed to seed facts: \(error)")
        }
    }
}
