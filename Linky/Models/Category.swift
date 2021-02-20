//
//  Categories.swift
//  Linky
//
//  Created by Riccardo Feingold on 19.02.21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title: String = ""
    let linkTiles = List<LinkTile>()
}
