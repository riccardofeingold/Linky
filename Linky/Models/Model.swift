//
//  Model.swift
//  Linky
//
//  Created by Riccardo Feingold on 01.01.21.
//

import Foundation
import SwiftUI
import Combine
import RealmSwift

class Model: ObservableObject {
    @Published var showPopUp = false
    @Published var showCalendar = false
    @Published var showInformation = false
    @Published var tappedLinktile: LinkTile?
    @Published var links: [LinkTile]!
    @Published var date = Date()
    
    // data settings
    var dataFilePath: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Links.plist")
    }
}
