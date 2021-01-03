//
//  AddPopUp.swift
//  Linky
//
//  Created by Riccardo Feingold on 01.01.21.
//

import SwiftUI

struct PopUp: View {
    @EnvironmentObject var model: Model
    @State var link: String = ""
    @State var name: String = ""
    
    var body: some View {
        ZStack {
                Color.white
                VStack {
                    Text("Add new link")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, content: {
                        Text("Name")
                            .font(.title2)
                        HStack {
                            Image(systemName: "tag")
                                .foregroundColor(.blue)
                                .rotationEffect(.degrees(10), anchor: .center)
                            TextField("example", text: $name)
                        }
                        .modifier(customViewModifier(roundnessOfCorner: 6, startColor: Color.orange, endColor: Color.pink, textColor: Color.black, textSize: 18))
                        
                        Text("Link")
                            .font(.title2)
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                            TextField("www.example.com", text: $link)
                        }
                        .modifier(customViewModifier(roundnessOfCorner: 6, startColor: Color.orange, endColor: Color.pink, textColor: Color.black, textSize: 18))
                    })
                    .padding()
                    
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            let linkTile = LinkTile(name: name, link: link)
                            model.links.append(linkTile)
                            
                            let encoder = PropertyListEncoder()
                            do {
                                let data = try encoder.encode(model.links)
                                try data.write(to: model.dataFilePath!)
                            } catch {
                                print(error)
                            }
                            
                            model.showPopUp = false
                        }, label: {
                            Text("Add")
                        })
                        Spacer()
                        Button(action: {
                            model.showPopUp = false
                        }, label: {
                            Text("Cancel")
                        })
                        Spacer()
                    }
                }.padding()
            }
            .frame(width: UIScreen.screenWidth/9*8, height: UIScreen.screenHeight/3*2)
            .cornerRadius(20).shadow(radius: 20)
    }
}


struct PopUp_Previews: PreviewProvider {
    static var previews: some View {
        PopUp()
    }
}
