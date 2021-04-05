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
    @State var homeIsPresented: Bool = false
    @State var forgotPasswordIsPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                LogoTextView()
                    .padding(.horizontal)
                Spacer()
                SignUpButton()
                    .padding(.horizontal)
            }
            
            Spacer()
            
            //Email adress field
            TextField("Email", text: $email)
                .font(.title2)
                .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .keyboardType(.emailAddress)
            
            //Password field
            SecureField("Password", text: $password)
                .font(.title2)
                .padding(EdgeInsets(top: 8, leading: 20, bottom: 8, trailing: 20))
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            //Sign in Button
            NavigationLink(
                destination: LinkListView()
                    .environmentObject(Model())
                    .colorScheme(.light),
                isActive: $homeIsPresented) {
                    ZStack {
                        Button(action: {
                            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                                if let e = error {
                                    print(e)
                                } else {
                                    homeIsPresented = true
                                }
                            }
                        }, label: {
                            HStack {
                                Spacer()
                                
                                Text("Sign In")
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .bold()
                                    .padding(.vertical)
                                
                                Spacer()
                            }
                        })
                        .background(Color.blue)
                        .cornerRadius(5.0)
                    }
                    .padding(.all)
                }
            
            //Forgot password
            NavigationLink(
                destination: ForgettingView(),
                isActive: $forgotPasswordIsPresented,
                label: {
                    Button(action: {
                        forgotPasswordIsPresented.toggle()
                    }, label: {
                        Text("Can't log in?")
                            .foregroundColor(.gray)
                    })
                })
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct SignUpButton: View {
    var body: some View {
        ZStack {
            Text("Sign Up")
                .foregroundColor(.blue)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 10.0)
                        .stroke(Color.blue, lineWidth: 1)
                )
        }
    }
}

struct LogoTextView: View {
    var body: some View {
        ZStack {
            Text("Linky")
                .font(Font.custom("Futura", size: UIScreen.symbolSize))
                .bold()
                .foregroundColor(.blue)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LoginView()
        }
    }
}
