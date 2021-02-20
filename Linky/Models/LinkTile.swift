//
//  LinkTile.swift
//  Linky
//
//  Created by Riccardo Feingold on 01.01.21.
//

import Foundation
import SwiftUI
import Combine
import RealmSwift

class LinkTile: Object, Identifiable {
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    @objc dynamic var link: String = ""
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "linkTiles")
}
