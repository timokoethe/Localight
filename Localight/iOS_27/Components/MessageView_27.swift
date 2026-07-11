//
//  MessageView_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import SwiftUI

#if LOCALIGHT_IOS27_SDK
/// Displays a single chat message using the iOS 27 interface.
@available(iOS 27.0, *)
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
                if let image = message.image {
                    Image(uiImage: image)
    
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                        .scaledToFit()
                        .frame(maxWidth: 260, maxHeight: 180, alignment: .trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                VStack(alignment: message.sender == .model ? .leading : .trailing, spacing: 8) {
                    if !message.text.isEmpty {
                        Text(message.text)
                            .foregroundStyle(message.sender == .user ? .white : .primary)
                    }
                }
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

#Preview("Messages with Images") {
    MessageView_27(
        message: Message_27(
            text: "Landscape attachment",
            sender: .user,
            image: UIImage(named: "Landscape"),
            tokenCount: 12
        ),
        showsTokenUsage: true
    )

    MessageView_27(
        message: Message_27(
            text: "Portrait attachment",
            sender: .user,
            image: UIImage(named: "Portrait"),
            tokenCount: 12
        ),
        showsTokenUsage: true
    )
}
#endif
