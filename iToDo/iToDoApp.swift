//
//  iToDoApp.swift
//  iToDo
//
//  Created by Joakim Pettersson on 2024-11-21.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers

@main
struct iToDoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Item.self])
        }
    }
}
