//
//  ShareViewController.swift
//  LinkyShareExtension
//
//  Created by Riccardo Feingold on 07.02.21.
//

import UIKit
import SwiftUI
import MobileCoreServices
import RealmSwift

@objc(ShareExtensionViewController)
class ShareViewController: UIViewController {
    let fileURL = URL(string: "file:///Users/riccardofeingold/Library/Developer/CoreSimulator/Devices/A64AEC18-5D3E-422B-A867-5C0D18B3F8AD/data/Containers/Shared/AppGroup/12F7DF59-DC63-4995-99B1-C4D998029FB6/default.realm")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = UIHostingController(rootView: ShareLinkPopUp(doneFunction: self.doneAction, cancelFunction: self.cancelAction))
        present(vc, animated: true, completion: nil)
    }
    
    func doneAction(_ name: String,_ text: String) {
        self.handleSharedLinks(nameOfWebsite: name, with: text)
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func cancelAction() -> Void {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey : "An error description"])
        self.extensionContext?.cancelRequest(withError: error)
        dismiss(animated: false) {
            print("Disapeared")
        }
    }
    
    private func handleSharedLinks(nameOfWebsite name: String,with text: String) {
//        Extracting the path to the URL that is being shared
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeURL as String
        print(attachments)
        for provider in attachments {
//            check if the content type is the same as we expected
            if provider.hasItemConformingToTypeIdentifier(contentType) {
                provider.loadItem(forTypeIdentifier: contentType, options: nil) { [unowned self] (data, error) in
//                    Handle the error here if you want
                    guard error == nil else {return}
                    if let url = data as? URL{
//                        let linkInfos = [name, url.absoluteString]
                        let newLinkTile = LinkTile()
                        newLinkTile.name = name
                        newLinkTile.text = text
                        newLinkTile.link = url.absoluteString
                        newLinkTile.id = UUID().hashValue
                        self.save(newLinkTile)
                        
                    }else {
                        fatalError("Impossible to save link!")
                    }
                }
            }
        }
    }
    
    private func save(_ link: LinkTile) {
//        UserDefaults.group.set(link, forKey: "sharedLinks")
        // Query and update from any thread
        DispatchQueue(label: "background").async {
            autoreleasepool {
                let realm = try! Realm(configuration: Realm.Configuration(fileURL: self.fileURL))
                try! realm.write {
                    realm.add(link)
                }
            }
        }
    }
}

struct ShareLinkPopUp: View {
    let doneFunction: (_ name: String,_ text: String) -> Void
    let cancelFunction: () -> Void
    @State var name: String = ""
    @State var text: String = ""
    
    var body: some View {
        VStack {
            Button(action: {
                cancelFunction()
            }, label: {
                HStack {
                    Spacer()
                    
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 20))
                }
            })
            
            TextField("Name your link", text: $name)
                .font(.title2)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            
            TextField("Notes", text: $text)
                .font(.body)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    doneFunction(name, text)
                }, label: {
                    ZStack {
                        
                        Text("Save")
                            .font(.body)
                            .foregroundColor(.white)
                            .bold()
                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
                            .background(Color.blue)
                            .cornerRadius(5.0)
                    }
                })
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
            }
        }
    }
}

extension UserDefaults {
  static let group = UserDefaults(suiteName: "group.linky")!
}


//MARK: - to find the realm file where things are stored
//                let fileURL = FileManager.default
//                    .containerURL(forSecurityApplicationGroupIdentifier: "group.linky")!
//                    .appendingPathComponent("default.realm")
//                print(fileURL.absoluteString)
