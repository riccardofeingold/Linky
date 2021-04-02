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
    
    let userDefault = UserDefaults.standard
    
    var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        print(db)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
    }
    
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
                    
                    LoginView()
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
