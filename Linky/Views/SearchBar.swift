//
//  SearchBar.swift
//  Linky
//
//  Created by Riccardo Feingold on 25.02.21.
//

import SwiftUI

class SearchBar: NSObject, ObservableObject {
    
    @Published var text: String = ""
    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    override init() {
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
    }
}

extension SearchBar: UISearchResultsUpdating {
   
    func updateSearchResults(for searchController: UISearchController) {
        
        // Publish search bar text changes.
        if let searchBarText = searchController.searchBar.text {
            self.text = searchBarText
        }
    }
}

struct SearchBarModifier: ViewModifier {
    
    let searchBar: SearchBar
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }
                .frame(width: 0, height: 0)
            )
    }
}

extension View {
    
    func add(_ searchBar: SearchBar) -> some View {
        return self.modifier(SearchBarModifier(searchBar: searchBar))
    }
}

//struct SearchBar: View {
//    @Binding var text: String
//
//    @State private var isEditing = false
//
//    var body: some View {
//        HStack {
//
//            TextField("Search ...", text: $text)
//                .padding(7)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//                .onTapGesture {
//                    self.isEditing = true
//                }
//
//            if isEditing {
//                Button(action: {
//                    self.isEditing = false
//                    self.text = ""
//                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//                }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .resizable()
//                        .foregroundColor(.blue)
//                        .frame(width: UIScreen.symbolSize / 2, height: UIScreen.symbolSize / 2)
//                        .scaledToFit()
//                }
//                .padding(.trailing, 10)
//                .transition(.move(edge: .trailing))
//                .animation(.linear(duration: 0.2))
//            }
//        }
//    }
//}
