//
//  LinkyApp.swift
//  Linky
//
//  Created by Riccardo Feingold on 03.01.21.
//

import SwiftUI

@main
struct LinkyApp: App {
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            LinkListView()
                .environmentObject(Model())
                .colorScheme(.light)
        }
    }
}
