//
//  Message_26.swift
//  Localight
//
//  Created by Timo Köthe on 06.07.25.
//

import Foundation

/// Represents an iOS 26 message exchanged between the model and the user.
/// Each `Message_26` contains a unique identifier, timestamp, message text, and sender information.
/// Conforms to `Identifiable` for use in lists and SwiftUI views.
struct Message_26: Identifiable {
    let id: UUID = UUID()
    var date: Date = Date()
    var text: String
    var sender: Sender_26
}

enum Sender_26 {
    case model
    case user
}
