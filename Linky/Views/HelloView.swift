//
//  HelloView.swift
//  Linky
//
//  Created by Riccardo Feingold on 21.03.21.
//

import SwiftUI
import Firebase

struct HelloView: View {
    init() {
        if Auth.auth().currentUser != nil {
            NavigationLink(
                destination: LinkListView()
                    .environmentObject(Model())
                    .colorScheme(.light),
                label: {
                    EmptyView()
                })
        }
    }
    
    var body: some View {
        VStack {
            Text("Hello!")
            
            NavigationLink(
                destination: RegisterView(),
                label: {
                    Text("Register")
                })
            
            NavigationLink(
                destination: LoginView(),
                label: {
                    Text("Login")
                })
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct HelloView_Previews: PreviewProvider {
    static var previews: some View {
        HelloView()
    }
}
