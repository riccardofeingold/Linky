//
//  Model.swift
//  Linky
//
//  Created by Riccardo Feingold on 01.01.21.
//

import Foundation
import SwiftUI
import Combine

class Model: ObservableObject {
    var dataFilePath: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Links.plist")
    }
    @Published var showPopUp = false
    @Published var links: [LinkTile] = []
}
