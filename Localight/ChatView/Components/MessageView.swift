//
//  MessageView.swift
//  Localight
//
//  Created by Timo Köthe on 08.07.25.
//

import SwiftUI

/// A view that displays a single chat message within the conversation.
///
/// The message is styled differently depending on the sender:
/// - **User messages** are right-aligned with a colored background and white text.
/// - **Model messages** are left-aligned with a neutral background and primary-colored text.
///
/// Messages are presented inside a padded and rounded container for readability.
/// This view is used as a building block within the main chat interface.
struct MessageView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.sender == .user { Spacer() }
            
            VStack (alignment: .leading) {
                Text(message.text)
                    .foregroundStyle(message.sender == .user ? .white : .primary)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(message.sender == .user ? Color(red: 0.459, green: 0.333, blue: 0.902) : .clear)
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: 10))
            
            if message.sender == .model { Spacer() }
        }
        .padding(.horizontal)
    }
}

#Preview {
    MessageView(message: Message(text: "This is a message from the user", sender: .user))
    MessageView(message: Message(text: "This is a message from the user", sender: .model))
}
