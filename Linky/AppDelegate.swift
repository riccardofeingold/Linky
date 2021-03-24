//
//  AppDelegate.swift
//  Linky
//
//  Created by Riccardo Feingold on 02.03.21.
//

import Foundation
import SwiftUI
import UIKit
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        print(db)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        
        return true
    }
}
