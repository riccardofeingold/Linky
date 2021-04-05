//
//  LoginView.swift
//  Linky
//
//  Created by Riccardo Feingold on 21.03.21.
//

import SwiftUI
import Firebase

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
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
                NavigationLink(
                    destination: LinkListView()
                        .environmentObject(Model())
                        .colorScheme(.light),
                    isActive: $isPresented) {
                        ZStack {
                            Button(action: {
                                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                                    if let e = error {
                                        print(e)
                                    } else {
                                        isPresented = true
                                    }
                                }
                            }, label: {
                                Text("Sign In")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                                    .background(Color.blue)
                                    .cornerRadius(5.0)
                            })
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
            }
            
            Spacer()
        }
        .navigationBarTitle("Login")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
