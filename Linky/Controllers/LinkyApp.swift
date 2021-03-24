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
    @State var loggedIn = false
    
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
    //            LinkListView()
    //                .environmentObject(Model())
    //                .colorScheme(.light)
                
            }
            .onAppear {
                let defaults = UserDefaults.standard
                if let signedInPerson = defaults.object(forKey: "signedInPerson") as? Data {
                    let decoder = JSONDecoder()
                    if let loadedUser = try? decoder.decode(User.self, from: signedInPerson) {
                        Auth.auth().signIn(withEmail: loadedUser.email, password: loadedUser.password) { (authResult, error) in
                            if error == nil {
                                loggedIn = true
                                print("Yes!")
                            }
                        }
                    }
                }
            }
        }
    }
}
