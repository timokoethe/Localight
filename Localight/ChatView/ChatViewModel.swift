//
//  ChatViewModel.swift
//  Localight
//
//  Created by Timo Köthe on 07.07.25.
//

import Foundation
import FoundationModels

@Observable class ChatViewModel {
    let session: LanguageModelSession = LanguageModelSession(instructions: """
            Act as the best buddie. Keep your answer short.
            """)
    
    var inputText: String = ""
    var prompt: String = ""
    var isResponding: Bool = false
    var messages: [Message] = []
    
    func getResponse() async {
        isResponding = true
        messages.append(Message(text: inputText, sender: .user))
        prompt = inputText
        inputText = ""
        do {
            let response = try await session.respond(to: prompt).content
            let message = Message(text: response, sender: .model)
            messages.append(message)
        } catch {
            let message = Message(text: error.localizedDescription, sender: .model)
            messages.append(message)
        }
        isResponding = false
    }
}
