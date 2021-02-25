//
//  SearchBar.swift
//  Linky
//
//  Created by Riccardo Feingold on 25.02.21.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
 
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .foregroundColor(.blue)
                        .frame(width: UIScreen.symbolSize / 2, height: UIScreen.symbolSize / 2)
                        .scaledToFit()
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.linear(duration: 0.2))
            }
        }
    }
}
