//
//  ContentView_26.swift
//  Localight
//
//  Created by Timo Köthe on 06.07.25.
//

import SwiftUI
import FoundationModels

/// The iOS 26 app root view.
///
/// Displays the chat interface when the on-device language model is available.
/// Otherwise, it presents a fallback screen explaining why the model cannot be used.
struct ContentView_26: View {
    // Create a reference to the system language model.
    private var model = SystemLanguageModel.default
    
    var body: some View {
        // Checks the local model's availability
        switch model.availability {
        case .available:
            ChatView_26()
                .tabItem {
                    Label("Chat", systemImage: "message")
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
    ContentView_26()
}
