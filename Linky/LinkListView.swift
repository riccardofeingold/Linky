//
//  LinkListView.swift
//  Linky
//
//  Created by Riccardo Feingold on 20.12.20.
//

import Combine
import Foundation
import SwiftUI

//MARK: - Additional Data like UIScreen sizes etc.
extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

//MARK: - ViewModifiers
struct customViewModifier: ViewModifier {
    var roundnessOfCorner: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color
    var textSize: CGFloat
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundnessOfCorner)
            .padding(3)
            .foregroundColor(textColor)
            .overlay(RoundedRectangle(cornerRadius: roundnessOfCorner).stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing)))
            .font(.custom("Open Sans", size: textSize))
            .shadow(radius: 10)
    }
}

//MARK: - LinkListView
struct LinkListView: View {
    @EnvironmentObject var model: Model
    
    var body: some View {
        ZStack{
            List(model.links){ links in
                LinkTileRow(linkTile: links)
            }
            
            Button(action: addLinkToList, label: {
                Text("Add")
                    .font(.title2)
                    .bold()
            })
            .position(x: UIScreen.screenWidth/10*8, y: UIScreen.screenHeight/10*9)

            if (model.showPopUp) {
                PopUp()
                    .transition(.move(edge: .bottom))
                    .animation(.easeOut)
            }
        }
        .onAppear{
            load_links()
        }
    }
    
    func load_links() {
        if let data = try? Data(contentsOf: model.dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                model.links = try decoder.decode([LinkTile].self, from: data)
            } catch {
                print(error)
            }
        }
    }
    
    func addLinkToList() -> Void {
        model.showPopUp = true
    }
}

struct LinkTileRow: View {
    var linkTile: LinkTile
    
    var body: some View {
        VStack (alignment: .leading, spacing: nil) {
            Text(linkTile.name)
                .font(.title)
                .bold()
                .foregroundColor(.blue)
            Text(linkTile.link)
                .font(.body)
                .fontWeight(.medium)
                .lineLimit(2)
        }
    }
}

struct LinkListView_Previews: PreviewProvider {
    static var previews: some View {
        LinkListView().environmentObject(Model())
        PopUp().previewLayout(.sizeThatFits)
    }
}
