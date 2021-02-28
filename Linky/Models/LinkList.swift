//
//  LinkList.swift
//  Linky
//
//  Created by Riccardo Feingold on 28.02.21.
//

import Foundation

struct LinkList: Identifiable {
    var id: Int
    var name: String = ""
    var link: String = ""
    var text: String = ""
}

extension LinkList {
    init(linkTile: LinkTile) {
        id = linkTile.id
        name = linkTile.name
        link = linkTile.link
        text = linkTile.text
    }
}
