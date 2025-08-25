//
//  LocalightApp.swift
//  Localight
//
//  Created by Timo Köthe on 06.07.25.
//

import SwiftUI

/// The main application entry point.
///
/// `LocalightApp` defines the app’s lifecycle using the SwiftUI `App` protocol.
/// It creates a single `WindowGroup` scene that displays the `ContentView`
/// as the root view of the application.
///
/// This is where the app launches and sets up its initial UI.
@main
struct LocalightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
