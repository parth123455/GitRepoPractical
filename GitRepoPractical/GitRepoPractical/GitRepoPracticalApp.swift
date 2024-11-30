//
//  GitRepoPracticalApp.swift
//  GitRepoPractical
//
//  Created by Parth gondaliya on 30/11/24.
//

import SwiftUI

@main
struct GitRepoPracticalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            GitReposView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
