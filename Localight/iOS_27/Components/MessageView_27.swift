//
//  MessageView_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import SwiftUI

/// Displays a single chat message using the iOS 27 interface.
struct MessageView_27: View {
    @State private var pop = false

    let message: Message_27
    let showsTokenUsage: Bool
    private let generator = UIImpactFeedbackGenerator(style: .medium)
    private let uiPasteboard = UIPasteboard.general

    var body: some View {
        HStack {
            if message.sender == .user {
                Spacer()
            }

            VStack(alignment: message.sender == .model ? .leading : .trailing) {
                Text(message.text)
                    .foregroundStyle(message.sender == .user ? .white : .primary)
                    .padding(12)
                    .background(message.sender == .user ? Color("Tint") : .clear)
                    .background(.thinMaterial)
                    .clipShape(.rect(cornerRadius: 15))

                if showsTokenUsage, let tokenCount = message.tokenCount {
                    Text("\(tokenCount) \(message.sender == .user ? "input" : "output") tokens")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .containerRelativeFrame(
                .horizontal,
                alignment: message.sender == .model ? .leading : .trailing
            ) { length, _ in
                length / 1.2
            }

            if message.sender == .model {
                Spacer()
            }
        }
        .padding(.horizontal)
        .contentTransition(.interpolate)
        .animation(.easeInOut(duration: 0.2), value: message.text)
        .scaleEffect(pop ? 1.08 : 1.0)
        .animation(.easeOut(duration: 0.20), value: pop)
        .onLongPressGesture {
            pop.toggle()
            uiPasteboard.string = message.text
            generator.prepare()
            generator.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) {
                pop = false
            }
        }
    }
}

#Preview {
    MessageView_27(
        message: Message_27(text: "Hi there!", sender: .user, tokenCount: 8),
        showsTokenUsage: true
    )
    MessageView_27(
        message: Message_27(text: "Hi there!", sender: .model, tokenCount: 12),
        showsTokenUsage: true
    )
}
