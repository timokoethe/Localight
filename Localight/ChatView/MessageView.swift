//
//  MessageView.swift
//  Localight
//
//  Created by Timo Köthe on 08.07.25.
//

import SwiftUI

struct MessageView: View {
    let message: Message
    
    var body: some View {
           
            HStack {
                if message.sender == .user {
                    Spacer()
                }
                
                VStack (alignment: .leading) {
                    Text(message.text)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.white)
                }
                .padding()
                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: 10))
                
                if message.sender == .model {
                    Spacer()
                }
            }
            .padding(.horizontal)
    }
}

#Preview {
    MessageView(message: Message(text: "This is a message from the user", sender: .user)).background(.black)
}
