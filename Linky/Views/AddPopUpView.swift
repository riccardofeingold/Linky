//
//  AddPopUp.swift
//  Linky
//
//  Created by Riccardo Feingold on 01.01.21.
//

import SwiftUI
import UIKit
import RealmSwift

extension Color {
    static let lightGray: Color = Color(UIColor.systemGray6)
}



//MARK: - ViewModifiers
struct customViewModifier: ViewModifier {
    var roundnessOfCorner: CGFloat
    var color: Color
    var textColor: Color
    var textSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(color)
            .cornerRadius(roundnessOfCorner)
            .padding(.leading)
            .padding(.trailing)
            .foregroundColor(textColor)
            .font(.custom("Open Sans", size: textSize))
    }
}

// MARK: - AddPopView
struct AddPopUpView: View {
    @EnvironmentObject var model: Model
    @State var link: String = ""
    @State var name: String = ""
    
    let realm = try! Realm()
    
    var body: some View {
        ZStack {
            Color.white
            VStack (alignment: .leading, spacing: nil) {
                Text("Add new link")
                    .font(Font.custom("Helvetica Neue", fixedSize: 25).weight(.medium))
                    .foregroundColor(.blue)
                    .padding()
            
                Text("Name")
                    .font(Font.custom("Helvetica Neue", fixedSize: 20).weight(.regular))
                    .foregroundColor(.blue)
                    .padding(.leading)
                
                HStack {
                    Image(systemName: "tag")
                        .foregroundColor(.blue)
                        .rotationEffect(.degrees(10), anchor: .center)
                    TextField("example", text: $name)
                }
                .modifier(customViewModifier(roundnessOfCorner: 6, color: Color.lightGray, textColor: Color.black, textSize: 16))
                
                Text("Link")
                    .font(Font.custom("Helvetica Neue", fixedSize: 20).weight(.regular))
                    .foregroundColor(.blue)
                    .padding(.leading)
            
                HStack {
                    Image(systemName: "link")
                        .foregroundColor(.blue)
                    TextField("example.com", text: $link)
                        .keyboardType(.URL)
                }
                .modifier(customViewModifier(roundnessOfCorner: 6, color: Color.lightGray, textColor: Color.black, textSize: 16))
                
                Button(action: {
                    model.showCalendar = true
                }, label: {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: UIScreen.symbolSize, height: UIScreen.symbolSize, alignment: .center)
                        .scaledToFit()
                        .foregroundColor(Color.yellow)
                })
                .padding(.leading)
                
                HStack {
                    FilledButtonWithRounderCorners(text: "Add", color: .blue) {
                        let linkTile = LinkTile()
                        linkTile.id = UUID().hashValue
                        linkTile.name = name
                        linkTile.link = link
                        
                        self.save(linkTile)
                        
                        model.showPopUp = false
                    }
                    .padding(.leading)
                    
                    Spacer()
                    
                    FilledButtonWithRounderCorners(text: "Cancel", color: .red) {
                        model.showPopUp = false
                    }
                    
                    Spacer()
                }
            }.padding()
        }
        .frame(width: UIScreen.addPopUpViewWidth, height: UIScreen.addPopUpViewHeight)
        .cornerRadius(20).shadow(radius: 20)
    }
    
//    Save Links
    func save(_ link: LinkTile) {
        do {
            try realm.write{
                realm.add(link)
            }
        } catch {
            print("Error message: \(error)")
        }
    }
}

struct FilledButtonWithRounderCorners: View {
    var text: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.white)
                .font(.body)
                .bold()
        })
        .frame(width: UIScreen.addPopUpButtonWidth, height: UIScreen.addPopUpButtonHeight)
        .background(color)
        .cornerRadius(10)
    }
}

//extension View {
//    func titleFont(bigOrSmall size: Bool,color c: Color, weight w: Font.Weight) -> some View {
//        self.modifier(TitleFont(size: size, color: c, weight: w))
//    }
//}
//
//struct TitleFont: ViewModifier {
//    var size: Bool
//    var color: Color
//    var weight: Font.Weight
//
//    func body(content: Content) -> some View {
//        content
//            .font(Font.custom("Helvetica Neue", size: self.size ? 25 : 20).weight(weight))
//            .foregroundColor(color)
//            .padding()
//    }
//}

struct PopUp_Previews: PreviewProvider {
    static var previews: some View {
        AddPopUpView().environmentObject(Model())
    }
}
