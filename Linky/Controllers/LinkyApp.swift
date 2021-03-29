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
    @Environment(\.scenePhase) var scenePhase
    @State var loggedIn = false
    
    init() {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        print(db)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
    }
    
    //For managagin users
    var handle: AuthStateDidChangeListenerHandle?
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ZStack {
                    NavigationLink(destination: LinkListView()
                            .environmentObject(Model())
                            .colorScheme(.light),
                                   isActive: $loggedIn){
                        EmptyView()
                    }
                    
                    HelloView()
                }
            }
            .onAppear {
                if (Auth.auth().currentUser != nil) {
                    loggedIn = true
                }
            }
        }
    }
}
