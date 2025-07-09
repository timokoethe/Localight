//
//  TypebarView.swift
//  Localight
//
//  Created by Timo Köthe on 08.07.25.
//

import SwiftUI

struct TypebarView: View {
    @Bindable var vm: ChatViewModel
    
    var body: some View {
        HStack {
            TextField("", text: $vm.inputText)
                .foregroundStyle(.white)

            Button(role: .confirm) {
                Task {
                    await vm.getResponse()
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30)
                    .padding(2)
            }
            .foregroundStyle(vm.inputText.isEmpty ? Color.gray : Color.purple)
            .disabled(vm.isResponding ? true : false)
            .disabled(vm.inputText.isEmpty ? true : false)
        }
        .padding(5)
        .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 10))
        .padding()
    }
}

#Preview {
    TypebarView(vm: ChatViewModel()).background(.gray)
}
