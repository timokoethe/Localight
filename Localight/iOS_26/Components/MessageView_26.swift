//
//  MessageView_26.swift
//  Localight
//
//  Created by Timo Köthe on 08.07.25.
//

import Foundation
import SwiftUI

/// The iOS 26 view for a single chat message.
///
/// The message is styled differently depending on the sender:
/// - **User messages** are right-aligned with a colored background and white text.
/// - **Model messages** are left-aligned with a neutral background and primary-colored text.
///
/// Messages are presented inside a padded and rounded container for readability.
/// This view is used as a building block within the main chat interface.
struct MessageView_26: View {
    let message: Message_26

    private var renderedText: AttributedString {
        guard message.sender == .model else {
            return AttributedString(message.text)
        }

        return (try? AttributedString(
            markdown: message.text,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )) ?? AttributedString(message.text)
    }
        
    var body: some View {
        HStack {
            if message.sender == .user { Spacer() }
            
            Text(renderedText)
                .foregroundStyle(message.sender == .user ? .white : .primary)
                .padding(12)
                .background(message.sender == .user ? Color("Tint") : .clear)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 15))
                .containerRelativeFrame(.horizontal, alignment: message.sender == .model ? .leading : .trailing) { len, _  in
                        return len / 1.2
                }
            
            if message.sender == .model { Spacer() }
        }
        .padding(.horizontal)
        .contentTransition(.interpolate)
        .animation(.easeInOut(duration: 0.2), value: message.text)
    }
}

#Preview {
    MessageView_26(message: Message_26(text: "Hi there!", sender: .user))
    MessageView_26(message: Message_26(text: "Hi **there**! Try `Markdown`.", sender: .model))
    MessageView_26(message: Message_26(text: "This is a message from the model, which is very long for demonstration purposes only.", sender: .model))
    MessageView_26(message: Message_26(text: "This is a message from the user, which is very long for demonstration purposes only.", sender: .user))
}
