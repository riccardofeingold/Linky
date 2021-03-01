//
//  LinkListView.swift
//  Linky
//
//  Created by Riccardo Feingold on 20.12.20.
//

import Combine
import Foundation
import SwiftUI
import RealmSwift

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
    let config: Realm.Configuration
    @State var searchTerm: String = ""
    @ObservedObject var linkArray: BindableResults<LinkTile>
    @ObservedObject var searchBar = SearchBar()
    @EnvironmentObject var model: Model
    
    private let dateFormatter = DateFormatter()
    
    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.blue)]
        
        config = Realm.getConfigurationForSpecificGroup(groupName: "group.linky")
        self.linkArray = BindableResults(results: try! Realm(configuration: config).objects(LinkTile.self))
    }

    var body: some View {
        NavigationView {
            ZStack{
                List {
                    ForEach(linkArray.results.filter({searchBar.text.isEmpty ? true : $0.name.localizedLowercase.contains(searchBar.text.lowercased())})){ links in
                        LinkTileRow(linkTile: links)
                    }
                    .onDelete(perform: { indexSet in
                        let realm = try! Realm(configuration: config)
                        
                        if let index = indexSet.first {
                            let deleteLink = linkArray.results[index]
                            try! realm.write {
                                realm.delete(deleteLink)
                            }
                        }
                    })
                    .onMove(perform: { indices, newOffset in
                        
                    })
                }
                .padding(.all, 0)
                .listStyle(PlainListStyle())
                .add(self.searchBar)
                
                if model.showInformation {
                    InformationView(link: model.tappedLinktile!.link, linkName: model.tappedLinktile!.name, linkText: model.tappedLinktile?.text ?? "")
                }
                HStack {
                    Spacer()
                    
                    VStack {
                        Spacer()
                        
                        Button(action: {
                            print("Edit")
                        }, label: {
                            ZStack {
                                Circle()
                                    .size(width: UIScreen.symbolSize, height: UIScreen.symbolSize)
                                    .foregroundColor(.white)
                                    .frame(width: UIScreen.symbolSize, height: UIScreen.symbolSize, alignment: .center)
                                    .padding(EdgeInsets(top: 0, leading: 60, bottom: 20, trailing: 0))
                                    .shadow(radius: 1)

                                Image(systemName: "pencil.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.symbolSize, height: UIScreen.symbolSize, alignment: .center)
                                    .padding(EdgeInsets(top: 0, leading: 60, bottom: 20, trailing: 0))
                                    .foregroundColor(.blue)
                            }
                        })
                        .padding(.trailing, 20)
                    }
                }
            }
            .navigationBarTitle("Linky")
        }
    }
}

//MARK: - LinkCell
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
        }
    }
}

struct LinkListView_Previews: PreviewProvider {
    static var previews: some View {
        LinkListView().environmentObject(Model())
        AddPopUpView().previewLayout(.sizeThatFits).environmentObject(Model())
    }
}

//MARK: - Add search bar to navigationbar
final class ViewControllerResolver: UIViewControllerRepresentable {
    
    let onResolve: (UIViewController) -> Void
        
    init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
    }
    
    func makeUIViewController(context: Context) -> ParentResolverViewController {
        ParentResolverViewController(onResolve: onResolve)
    }
    
    func updateUIViewController(_ uiViewController: ParentResolverViewController, context: Context) { }
}

class ParentResolverViewController: UIViewController {
    
    let onResolve: (UIViewController) -> Void
    
    init(onResolve: @escaping (UIViewController) -> Void) {
        self.onResolve = onResolve
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(onResolve:) to instantiate ParentResolverViewController.")
    }
        
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        
        if let parent = parent {
            onResolve(parent)
        }
    }
}

//MARK: - With this Class you can use can combine realm results with swiftui data logic
class BindableResults<Element>: ObservableObject where Element: RealmSwift.RealmCollectionValue {

    var results: Results<Element>
    private var token: NotificationToken!

    init(results: Results<Element>) {
        self.results = results
        lateInit()
    }

    func lateInit() {
        token = results.observe { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    deinit {
        token.invalidate()
    }
}

//                    .opacity(model.showCalendar ? 0.3 : 1)

//                if model.showCalendar {
//                    CalendarView()
//                        .cornerRadius(20)
//                        .transition(.move(edge: .bottom))
//                        .animation(.easeOut)
//                }
// if (model.showPopUp) {
//AddPopUpView()
//    .transition(.move(edge: .bottom))
//    .animation(.easeOut)
//}
//
