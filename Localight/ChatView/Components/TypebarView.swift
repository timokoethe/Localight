//
//  TypebarView.swift
//  Localight
//
//  Created by Timo Köthe on 08.07.25.
//

import SwiftUI

/// A view that provides the input area for composing and sending chat messages.
///
/// The type bar consists of:
/// - A `TextField` for entering user input
/// - A send button with a paper plane icon that triggers the model response
///
/// The send button is disabled while a response is being generated (`isResponding`)
/// or when the input field is empty.
/// The entire type bar is styled with padding and a rounded rectangular border
/// to distinguish it from the chat area.
///
/// This view is typically placed at the bottom of the chat screen as the main input control.
struct TypebarView: View {
    @Bindable var vm: ChatViewModel
    
    var body: some View {
        HStack {
            TextField("Type here ...", text: $vm.inputText)

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
                    .padding(2)
            }
            .foregroundStyle(vm.inputText.isEmpty ? Color.gray : Color(red: 0.459, green: 0.333, blue: 0.902))
            .disabled(vm.isResponding ? true : false)
            .disabled(vm.inputText.isEmpty ? true : false)
        }
        .padding(5)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 2)
        )
        .padding()
    }
}

#Preview {
    TypebarView(vm: ChatViewModel())
}
