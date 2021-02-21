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
//        let fileURL = FileManager.default
//            .containerURL(forSecurityApplicationGroupIdentifier: "group.linky")!
//            .appendingPathComponent("default.realm")
//        let config = Realm.Configuration(fileURL: fileURL)
//        self.realm = try! Realm(configuration: config)
        
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
            print("World")
//            check if the content type is the same as we expected
            if provider.hasItemConformingToTypeIdentifier(contentType) {
                provider.loadItem(forTypeIdentifier: contentType, options: nil) { [unowned self] (data, error) in
//                    Handle the error here if you want
                    guard error == nil else {return}
                    print("Hello")
                    if let url = data as? URL{
                        let linkInfos = [name, url.absoluteString]
                        self.save(linkInfos)
                        
                    }else {
                        fatalError("Impossible to save link!")
                    }
                }
            }
        }
    }
    
    private func save(_ link: [String]) {
        UserDefaults.group.set(link, forKey: "sharedLinks")
//        do {
//            try realm.write{
//                realm.add(link)
//            }
//        } catch {
//            print("Error message: \(error)")
//        }
    }
}

struct ShareLinkPopUp: View {
    let doneFunction: (_ name: String) -> Void
    let cancelFunction: () -> Void
    @State var name: String = ""
    
    var body: some View {
        TextField("Enter name of Link", text: $name)
        
        VStack {
            Button("Cancel") {
                cancelFunction()
            }
            Button("Done") {
                doneFunction(name)
            }
        }
    }
}

extension UserDefaults {
  static let group = UserDefaults(suiteName: "group.linky")!
}
