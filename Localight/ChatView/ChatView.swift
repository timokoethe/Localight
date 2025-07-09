//
//  ChatView.swift
//  Localight
//
//  Created by Timo Köthe on 07.07.25.
//

import SwiftUI

struct ChatView: View {
    @State private var vm = ChatViewModel()
    
    private let gradientStopsStyle = [
        Gradient.Stop(color: .purple, location: 0),
        Gradient.Stop(color: .blue, location: 0.2),
        Gradient.Stop(color: .black, location: 1)
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(stops: gradientStopsStyle, startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea(.all)
            
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
}

#Preview {
    ChatView()
}
