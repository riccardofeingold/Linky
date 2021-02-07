//
//  ShareViewController.swift
//  LinkyShareExtension
//
//  Created by Riccardo Feingold on 07.02.21.
//

import UIKit
import SwiftUI
import MobileCoreServices

@objc(ShareExtensionViewController)
class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = UIHostingController(rootView: ShareLinkPopUp(doneFunction: self.doneAction, cancelFunction: self.cancelAction))
        present(vc, animated: true, completion: nil)
//        self.handleSharedLinks()
    }
    
    @objc private func doneAction() {
        self.handleSharedLinks()
        self.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    @objc public func cancelAction() -> Void {
        let error = NSError(domain: "some.bundle.identifier", code: 0, userInfo: [NSLocalizedDescriptionKey : "An error description"])
        self.extensionContext?.cancelRequest(withError: error)
        dismiss(animated: false) {
            print("Disapeared")
        }
    }
    
    private func handleSharedLinks() {
//        Extracting the path to the URL that is being shared
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeURL as String
        
        for provider in attachments {
//            check if the content type is the same as we expected
            if provider.hasItemConformingToTypeIdentifier(contentType) {
                provider.loadItem(forTypeIdentifier: contentType, options: nil) { [unowned self] (data, error) in
//                    Handle the error here if you want
                    guard error == nil else {return}
                    
                    if let url = data as? URL, let linkData = try? Data(contentsOf: url) {
                        self.save(linkData, key: "sharedLink", value: linkData)
                    }else {
                        fatalError("Impossible to save image!")
                    }
                }
            }
        }
    }
    
    private func save(_ data: Data, key: String, value: Any) {
        let userDefaults = UserDefaults()
        userDefaults.set(data, forKey: key)
    }
}

struct ShareLinkPopUp: View {
    let doneFunction: () -> Void
    let cancelFunction: () -> Void
    var body: some View {
        VStack {
            Button("Cancel") {
                cancelFunction()
            }
            Button("Done") {
                doneFunction()
            }
        }
    }
}
