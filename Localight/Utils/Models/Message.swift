//
//  Message.swift
//  Localight
//
//  Created by Timo Köthe on 06.07.25.
//
import Foundation

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
