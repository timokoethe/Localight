//
//  TypebarView_26.swift
//  Localight
//
//  Created by Timo Köthe on 08.07.25.
//

import SwiftUI

/// The iOS 26 input view for composing and sending chat messages.
///
/// The type bar consists of:
/// - A `TextField` for entering user input
/// - A send button with a paper plane icon that triggers the model response
///
/// The send button is disabled while a response is being generated (`isResponding`)
/// or when the input field is empty.
/// The type bar uses padding and a glass effect.
///
/// This view is typically placed at the bottom of the chat screen as the main input control.
struct TypebarView_26: View {
    @Bindable var vm: ChatViewModel_26
    
    var body: some View {
        HStack {
            TextField("Type here ...", text: $vm.inputText)
                .padding(.horizontal, 6)

            Button(role: .confirm) {
                Task {
                    if vm.isStreaming {
                        await vm.streamResponse()
                    } else {
                        await vm.getResponse()
                    }
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30)
                    .padding(.trailing, 6)
                    .padding(.vertical, 2)
            }
            .foregroundStyle(canSend ? Color("Tint") : .gray)
            .disabled(vm.isResponding)
            .disabled(!canSend)
        }
        .padding(6)
        .glassEffect()
        .padding()
    }

    private var canSend: Bool {
        !vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

#Preview {
    TypebarView_26(vm: ChatViewModel_26())
}
