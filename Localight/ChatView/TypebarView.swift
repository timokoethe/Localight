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
            TextField("Type here...", text: $vm.inputText)
                .textFieldStyle(.roundedBorder)
            
            
            Button(role: .confirm) {
                Task {
                    await vm.getResponse()
                }
            } label: {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 30)
            }
            .disabled(vm.isResponding ? true : false)
            .disabled(vm.inputText.isEmpty ? true : false)
            
        }
        .padding()
    }
}

#Preview {
    TypebarView(vm: ChatViewModel())
}
