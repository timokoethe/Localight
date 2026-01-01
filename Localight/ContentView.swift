//
//  ContentView.swift
//  Localight
//
//  Created by Timo Köthe on 06.07.25.
//

import SwiftUI
import FoundationModels

/// The root view of the app.
///
/// `ContentView` checks the availability of the local system language model
/// and displays the appropriate screen:
/// - If the model is available, the chat interface (`ChatView`) is shown.
/// - If unavailable, a `ContentUnavailableView` is presented with a reason,
///   such as device incompatibility, disabled Apple Intelligence,
///   the model still preparing, or other issues.
///
/// This view ensures that users always receive clear feedback about the model’s state
/// before interacting with the chat interface.
struct ContentView: View {
    // Create a reference to the system language model.
    private var model = SystemLanguageModel.default
    
    var body: some View {
        // Checks the local model's availability
        switch model.availability {
        case .available:
            TabView {
                ChatView()
                    .tabItem {
                        Label("Chat", systemImage: "speechbubble")
                    }
            }
        case .unavailable(.deviceNotEligible):
            ContentUnavailableView("This device is not supported.", systemImage: "nosign")
        case .unavailable(.appleIntelligenceNotEnabled):
            ContentUnavailableView("Apple Intelligence is turned off. Please enable it in Settings.", systemImage: "nosign")
        case .unavailable(.modelNotReady):
            ContentUnavailableView("The model is still downloading or preparing. Please try again later.", systemImage: "nosign")
        case .unavailable(_):
            ContentUnavailableView("The model is currently unavailable.", systemImage: "nosign")
        }
    }
}

#Preview {
    ContentView()
}
