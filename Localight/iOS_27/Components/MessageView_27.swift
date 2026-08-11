//
//  MessageView_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import Foundation
import SwiftUI

#if LOCALIGHT_IOS27_SDK
/// Displays a single chat message using the iOS 27 interface.
@available(iOS 27.0, *)
struct MessageView_27: View {
    let message: Message_27
    let showsTokenUsage: Bool

    private var renderedText: AttributedString {
        guard message.sender == .model else {
            return AttributedString(message.text)
        }

        return (try? AttributedString(
            markdown: message.text,
            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
        )) ?? AttributedString(message.text)
    }

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
                        Text(renderedText)
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
    }
}

@available(iOS 27.0, *)
#Preview {
    MessageView_27(
        message: Message_27(text: "Hi there!", sender: .user, tokenCount: 8),
        showsTokenUsage: true
    )
    MessageView_27(
        message: Message_27(text: "Hi **there**! Try `Markdown`.", sender: .model, tokenCount: 12),
        showsTokenUsage: true
    )
}

@available(iOS 27.0, *)
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
