//
//  LinkyApp.swift
//  Linky
//
//  Created by Riccardo Feingold on 03.01.21.
//

import SwiftUI

@main
struct LinkyApp: App {
    var body: some Scene {
        WindowGroup {
            LinkListView()
                .environmentObject(Model())
        }
    }
}
