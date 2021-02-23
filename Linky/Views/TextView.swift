//
//  TextView.swift
//  Linky
//
//  Created by Riccardo Feingold on 23.02.21.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView(frame: CGRect(x: 20.0, y: 90.0, width: 250.0, height: 100.0))
        
        textView.textAlignment = NSTextAlignment.justified
       
        // Update UITextView font size and colour
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.textColor = UIColor.white
        
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.font = UIFont(name: "Helvetica Neue", size: 17)
        
        // Make UITextView web links clickable
        textView.isSelectable = true
        textView.isEditable = false
        textView.dataDetectorTypes = UIDataDetectorTypes.link
        
        // Make UITextView corners rounded
        textView.layer.cornerRadius = 10
        
        // Enable auto-correction and Spellcheck
        textView.autocorrectionType = UITextAutocorrectionType.yes
        textView.spellCheckingType = UITextSpellCheckingType.yes
        
        // Make UITextView Editable
        textView.isEditable = true
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        
    }
}

struct TestView: View {
    var body: some View {
        TextView()
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
