//
//  LinkTile.swift
//  Linky
//
//  Created by Riccardo Feingold on 01.01.21.
//

import Foundation
import SwiftUI
import Combine

struct LinkTile: Identifiable, Codable {
    var id = UUID()
    var name: String
    var link: String
}
