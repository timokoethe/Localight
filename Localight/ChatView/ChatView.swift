//
//  ChatView.swift
//  Localight
//
//  Created by Timo Köthe on 07.07.25.
//

import SwiftUI

/// A view that presents the main chat interface, featuring a scrollable list of messages
/// and an input bar for composing new ones.
///
/// The layout is organized vertically: messages appear in a scrollable area,
/// while the input bar remains fixed at the bottom for quick interaction.
/// A progress indicator is shown as long as the model generates a response.
/// This view serves as the primary screen for chat-based interactions.
/// Messages are not persisted and will be lost once the application is closed.
struct ChatView: View {
    @State private var vm = ChatViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(vm.messages) { message in
                    MessageView(message: message)
                }
                
                // Shows a progress indicator as long as the model generates a response
                if vm.isResponding {
                    HStack {
                        ProgressView()
                        Spacer()
                    }
                    .padding(.horizontal)
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
