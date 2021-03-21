//
//  LinkyApp.swift
//  Linky
//
//  Created by Riccardo Feingold on 03.01.21.
//

import SwiftUI
import Firebase

@main
struct LinkyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HelloView()
    //            LinkListView()
    //                .environmentObject(Model())
    //                .colorScheme(.light)
            }
        }
    }
}
