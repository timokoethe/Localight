//
//  ChatView.swift
//  Localight
//
//  Created by Timo Köthe on 07.07.25.
//

import SwiftUI

struct ChatView: View {
    @State private var vm = ChatViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(vm.messages) { message in
                    MessageView(message: message)
                }
                Text(vm.prompter)
            }
            TypebarView(vm: vm)
        }
        
    }
}

#Preview {
    ChatView()
}
