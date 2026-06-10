//
//  ChatView_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import SwiftUI

/// The main chat interface for iOS 27.
struct ChatView_27: View {
    @State private var vm = ChatViewModel_27()

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    ForEach(vm.messages) { message in
                        MessageView_27(message: message)
                    }

                    if vm.isResponding && !vm.isStreaming {
                        HStack {
                            ProgressView()
                            Spacer()
                        }
                        .padding(.horizontal)
                    }

                    if vm.isResponding && vm.isStreaming {
                        HStack {
                            MessageView_27(
                                message: Message_27(
                                    text: vm.streamingResponse,
                                    sender: .model
                                )
                            )
                            Spacer()
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
                .defaultScrollAnchor(.bottom)
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    TypebarView_27(vm: vm)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Clear", systemImage: "trash", action: vm.resetSession)
                        .disabled(vm.isResponding || vm.messages.isEmpty)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView_27(vm: vm)) {
                        Image(systemName: "gear")
                    }
                    .disabled(vm.isResponding)
                }
            }
        }
    }
}

#Preview {
    ChatView_27()
}
