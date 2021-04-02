//
//  RegisterView.swift
//  Linky
//
//  Created by Riccardo Feingold on 21.03.21.
//

import SwiftUI
import Firebase

struct RegisterView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var isPresented: Bool = false
    
    let userDefault = UserDefaults.standard
    let launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
    
    var body: some View {
        VStack {
            Spacer()
            
            TextField("Email", text: $email)
                .font(.title2)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .font(.title2)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            
            HStack {
                Spacer()
                
                NavigationLink(
                    destination: LinkListView()
                        .environmentObject(Model())
                        .colorScheme(.light),
                    isActive: $isPresented) {
                        ZStack {
                            Text("Save")
                                .font(.body)
                                .foregroundColor(.white)
                                .bold()
                                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                .background(Color.blue)
                                .cornerRadius(5.0)
                        }
                        .onTapGesture {
                            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                                if let e = error {
                                    print(e)
                                } else {
                                    self.userDefault.set(true, forKey: "usersignedin")
                                    self.userDefault.synchronize()
//                                    let user = User(email: email, password: password)
//                                    let encoder = JSONEncoder()
//                                    if let encoded = try? encoder.encode(user) {
//                                        let defaults = UserDefaults.standard
//                                        defaults.set(encoded, forKey: "signedInPerson")
//                                    }
                                    isPresented = true
                                }
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
            }
            Spacer()
        }
        .navigationBarTitle("Registration")
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
