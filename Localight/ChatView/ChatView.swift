//
//  ChatView.swift
//  Localight
//
//  Created by Timo Köthe on 07.07.25.
//

import SwiftUI

/// A view that displays a chat interface, including a scrollable list of messages and an input typebar for composing new messages.
///
/// The chat interface is organized vertically, with messages displayed in a scrollable area and a typebar at the bottom for user input.
/// This view is intended to be used as the main screen for chat interactions.
struct ChatView: View {
    @State private var vm = ChatViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(vm.messages) { message in
                    MessageView(message: message)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            .defaultScrollAnchor(.bottom)
            TypebarView(vm: vm)
        }
    }
}

#Preview {
    ChatView()
}
