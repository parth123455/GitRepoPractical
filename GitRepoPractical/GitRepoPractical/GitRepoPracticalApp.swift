//
//  GitRepoPracticalApp.swift
//  GitRepoPractical
//
//  Created by Parth gondaliya on 30/11/24.
//
import SwiftUI
import CoreData

@main
struct GitRepoPracticalApp: App {
    let persistenceController = PersistenceController.shared
    let connectivity = Connectivity()

    var body: some Scene {
        WindowGroup {
            GitReposView(context: persistenceController.container.viewContext, connectivity: connectivity)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

