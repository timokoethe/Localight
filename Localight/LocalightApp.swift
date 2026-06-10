//
//  LocalightApp.swift
//  Localight
//
//  Created by Timo Köthe on 06.07.25.
//

import SwiftUI

/// The main entry point, selecting the iOS 26 or iOS 27 interface.
@main
struct LocalightApp: App {
    var body: some Scene {
        WindowGroup {
            if #available(iOS 27.0, *) {
                ContentView_27()
            } else {
                ContentView_26()
            }
        }
    }
}
