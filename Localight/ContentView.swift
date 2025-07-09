//
//  ContentView.swift
//  Localight
//
//  Created by Timo Köthe on 06.07.25.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    // Create a reference to the system language model.
    private var model = SystemLanguageModel.default

    var body: some View {
        switch model.availability {
        case .available:
            ChatView()
        case .unavailable(.deviceNotEligible):
            ContentUnavailableView("deviceNotEligible", systemImage: "nosign")
        case .unavailable(.appleIntelligenceNotEnabled):
            ContentUnavailableView("Apple Intelligence is off. Switch it on", systemImage: "nosign")
        case .unavailable(.modelNotReady):
            ContentUnavailableView("Model is not ready because of download or other reasons", systemImage: "nosign")
        case .unavailable(_):
            ContentUnavailableView("not available, no reason", systemImage: "nosign")
        }
    }
}

#Preview {
    ContentView()
}
