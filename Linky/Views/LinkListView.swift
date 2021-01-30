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
    //Device Size Infos
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
    
    //AddPopUpView Size Infos
    static let addPopUpViewWidth = UIScreen.screenWidth - 2 * UIScreen.screenWidth*0.15
    static var addPopUpViewHeight: CGFloat {
        return addPopUpViewWidth * 1.5
    }
    
    //Symbol Size
    static var symbolSize: CGFloat {
        return addPopUpViewWidth / 6
    }
    
    //Button Size Infos
    static var addPopUpButtonWidth: CGFloat {
        return addPopUpViewWidth / 3
    }
    static var addPopUpButtonHeight: CGFloat {
        return addPopUpViewHeight / 8
    }
    
    //information Screen
    static var informationViewWidth: CGFloat {
        return screenWidth * 0.9
    }
    
    static var informationViewHeight: CGFloat {
        return screenHeight * 0.6
    }
    
    static var informationViewImageSize: CGFloat {
        return informationViewWidth * 0.3
    }
}

//MARK: - LinkListView
struct LinkListView: View {
    @EnvironmentObject var model: Model
    private let dateFormatter = DateFormatter()

    var body: some View {
        ZStack{
            Group {
                List(model.links){ links in
                    LinkTileRow(linkTile: links)
                }
                
                Button(action: addLinkToList, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.symbolSize, height: UIScreen.symbolSize, alignment: .center)
                        .padding(EdgeInsets(top: 0, leading: 60, bottom: 20, trailing: 0))
                        .foregroundColor(.blue)
                })
                .position(x: UIScreen.screenWidth/10*8, y: UIScreen.screenHeight/10*9)
            }
            .opacity(model.showPopUp ? 0.3 : 1)
            .onTapGesture {
                print(model.date)
                model.showCalendar = false
            }
            
            if (model.showPopUp) {
                AddPopUpView()
                    .transition(.move(edge: .bottom))
                    .animation(.easeOut)
                    .opacity(model.showCalendar ? 0.3 : 1)

                if model.showCalendar {
                    CalendarView()
                        .cornerRadius(20)
                        .transition(.move(edge: .bottom))
                        .animation(.easeOut)
                }
            }
            
            if model.showInformation {
                InformationView(linkName: model.tappedLinktile!.name, link: model.tappedLinktile!.link, linkText: "asölkafösdlkjasöldj")
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
    @EnvironmentObject var model: Model
    
    var body: some View {
        ZStack {
            Color.white
            HStack {
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
                
                Spacer()
                
                Image(systemName: "camera")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
            }
        }
        .onTapGesture {
            model.showInformation = true
            model.tappedLinktile = linkTile
            print(linkTile.name)
        }
    }
}

struct LinkListView_Previews: PreviewProvider {
    static var previews: some View {
        LinkListView().environmentObject(Model())
        AddPopUpView().previewLayout(.sizeThatFits).environmentObject(Model())
    }
}
