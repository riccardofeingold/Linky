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
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = UIHostingController(rootView: ShareLinkPopUp(doneFunction: self.doneAction, cancelFunction: self.cancelAction))
        present(vc, animated: true, completion: nil)
    }
    
    func doneAction(_ name: String) {
        self.handleSharedLinks(nameOfWebsite: name)
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    func cancelAction() -> Void {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey : "An error description"])
        self.extensionContext?.cancelRequest(withError: error)
        dismiss(animated: false) {
            print("Disapeared")
        }
    }
    
    private func handleSharedLinks(nameOfWebsite name: String) {
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
                let fileURL = FileManager.default
                    .containerURL(forSecurityApplicationGroupIdentifier: "group.linky")!
                    .appendingPathComponent("default.realm")
                let realm = try! Realm(configuration: Realm.Configuration(fileURL: fileURL))
                try! realm.write {
                    realm.add(link)
                }
            }
        }
    }
}

struct ShareLinkPopUp: View {
    let doneFunction: (_ name: String) -> Void
    let cancelFunction: () -> Void
    @State var name: String = ""
    
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
            
            Spacer()
            
            HStack {
                Spacer()
                
                Button(action: {
                    doneFunction(name)
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
