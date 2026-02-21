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
    @State private var pop = false
    
    let message: Message
    private let generator: UIImpactFeedbackGenerator = .init(style: .medium)
    private let uiPasteboard: UIPasteboard = UIPasteboard.general
        
    var body: some View {
        HStack {
            if message.sender == .user { Spacer() }
            
            Text(message.text)
                .foregroundStyle(message.sender == .user ? .white : .primary)
                .padding(12)
                .background(message.sender == .user ? .purple : .clear)
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
        .scaleEffect(pop ? 1.08 : 1.0)
        .animation(.easeOut(duration: 0.20), value: pop)
        .onLongPressGesture {
            pop.toggle()
            uiPasteboard.string = message.text
            generator.prepare()
            generator.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                pop = false
            }
        }
    }
}

#Preview {
    MessageView(message: Message(text: "Hi there!", sender: .user))
    MessageView(message: Message(text: "Hi there!", sender: .model))
    MessageView(message: Message(text: "This is a message from the model, which is very long for demonstration purposes only.", sender: .model))
    MessageView(message: Message(text: "This is a message from the user, which is very long for demonstration purposes only.", sender: .user))
}
