//
//  ContentView_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import SwiftUI
import FoundationModels

/// The iOS 27 app root view.
struct ContentView_27: View {
    private var model = SystemLanguageModel.default

    var body: some View {
        switch model.availability {
        case .available:
            ChatView_27()
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
    ContentView_27()
}
