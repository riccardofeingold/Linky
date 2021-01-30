//
//  Calendar.swift
//  Linky
//
//  Created by Riccardo Feingold on 06.01.21.
//

import SwiftUI
import Foundation

struct CalendarView: View {
    private let calendar = Calendar(identifier: .gregorian)    
    @EnvironmentObject var model: Model
    
    var body: some View {
        ZStack {
            Color.white
            DatePicker("Select your date:", selection: $model.date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
                .frame(width: UIScreen.screenWidth / 1.2, height: UIScreen.screenHeight / 2.2, alignment: .center)
        }
        .frame(width: UIScreen.screenWidth / 1.2, height: UIScreen.screenHeight / 2.2, alignment: .center)
    }
}

struct CalendarView_Preview: PreviewProvider {
    static var previews: some View {
        CalendarView().previewLayout(.sizeThatFits)
            .environmentObject(Model())
    }
}
