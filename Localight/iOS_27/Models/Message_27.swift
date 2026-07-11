//
//  Message_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import Foundation
import UIKit

#if LOCALIGHT_IOS27_SDK
/// Represents a chat message in the iOS 27 implementation.
@available(iOS 27.0, *)
struct Message_27: Identifiable {
    let id = UUID()
    var date = Date()
    var text: String
    var sender: Sender_27
    var image: UIImage? = nil
    var tokenCount: Int? = nil
}

enum Sender_27 {
    case model
    case user
}
#endif
