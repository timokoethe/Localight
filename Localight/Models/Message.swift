//
//  Message.swift
//  Localight
//
//  Created by Timo Köthe on 06.07.25.
//
import Foundation

/// Represents a message exchanged between the model and the user.
/// Each `Message` contains a unique identifier, timestamp, message text, and sender information.
/// Conforms to `Identifiable` for use in lists and SwiftUI views.
struct Message: Identifiable {
    let id: UUID = UUID()
    var date: Date = Date()
    var text: String
    var sender: Sender
}

enum Sender {
    case model
    case user
}
