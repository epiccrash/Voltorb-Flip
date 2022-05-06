//
//  Voltorb_FlipApp.swift
//  Voltorb Flip
//
//  Created by Joey Perrino on 5/6/22.
//

import SwiftUI

@main
struct Voltorb_FlipApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
