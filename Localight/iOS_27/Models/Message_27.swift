//
//  Message_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import Foundation

/// Represents a chat message in the iOS 27 implementation.
struct Message_27: Identifiable {
    let id = UUID()
    var date = Date()
    var text: String
    var sender: Sender_27
}

enum Sender_27 {
    case model
    case user
}
