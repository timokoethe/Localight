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
            TextField("Type here ...", text: $vm.inputText)

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
