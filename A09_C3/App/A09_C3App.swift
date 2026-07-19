//
//  A09_C3App.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 14/07/26.
//

import SwiftUI
import SwiftData

@main
struct A09_C3App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            PantauanModel.self,
            Obat.self,
            KonsulModel.self
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
            MainTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}
