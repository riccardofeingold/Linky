//
//  CustomNavigationView.swift
//  Linky
//
//  Created by Riccardo Feingold on 25.02.21.
//

import SwiftUI

struct CustomNavigationView<Content: View, Destination : View>: View {
    let destination : Destination
    let navBarTitle : String
    let isRoot : Bool
    let isLast : Bool
    let color : Color
    let content: Content
    @State var active = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    init(destination: Destination, isRoot : Bool, isLast : Bool,color : Color, navBarTitle: String, @ViewBuilder content: () -> Content) {
        self.destination = destination
        self.isRoot = isRoot
        self.isLast = isLast
        self.color = color
        self.content = content()
        self.navBarTitle = navBarTitle
    }
    
    var body: some View {
    // some views
    NavigationView {
            GeometryReader { geometry in
                Color.white
                VStack {
                    ZStack() {
                        HStack {
                            Text(navBarTitle)
                                .foregroundColor(.blue)
                                .font(.largeTitle)
                                .bold()
                                .padding(.bottom, 0)
                                .padding(.leading, 15)
                                .padding(.top, 50)
                            Spacer()
                        }
                    }
                    Spacer()
                    
                    self.content
                    
                    Spacer()
                }
            }.navigationBarHidden(true)
        }
    }
}
