//
//  TypebarView_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import SwiftUI

/// Provides the iOS 27 input area for composing and sending messages.
struct TypebarView_27: View {
    @Bindable var vm: ChatViewModel_27

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
            .foregroundStyle(vm.inputText.isEmpty ? .gray : Color("Tint"))
            .disabled(vm.isResponding)
            .disabled(vm.inputText.isEmpty)
        }
        .padding(6)
        .glassEffect()
        .padding()
    }
}

#Preview {
    TypebarView_27(vm: ChatViewModel_27())
}
