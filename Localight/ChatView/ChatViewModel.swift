//
//  ChatViewModel.swift
//  Localight
//
//  Created by Timo Köthe on 07.07.25.
//

import Foundation
import FoundationModels

/// `ChatViewModel` is an observable class that manages the state and logic for a chat interface utilizing a language model session.
/// 
/// Responsibilities include:
/// - Managing user input and chat messages.
/// - Interfacing with `LanguageModelSession` to send prompts and handle responses.
/// - Tracking the status of responses and updating the UI accordingly.
/// 
/// Properties:
/// - `session`: Handles communication with the language model, initialized with specific instructions.
/// - `inputText`: The current text entered by the user.
/// - `prompt`: Stores the current prompt sent to the language model.
/// - `isResponding`: Indicates whether a response is currently being awaited from the model.
/// - `messages`: The list of chat messages exchanged between the user and the model.
/// 
/// Methods:
/// - `getResponse()`: Asynchronously sends the current prompt to the language model and appends both user and model messages to the chat, handling errors gracefully.
@Observable class ChatViewModel {
    private let session: LanguageModelSession = LanguageModelSession(instructions: "Act as the best buddie. Keep your answer short.")
    
    var inputText: String = ""          // The text currently entered by the user.
    var prompt: String = ""             // The finalized user input sent to the model.
    var isResponding: Bool = false      // Indicates whether the model is generating a response.
    var messages: [Message] = []        // A collection of all messages displayed in the chat view.
    
    /// Generates a response from the model based on the user’s current input.
    ///
    /// This function handles the full request–response cycle:
    /// - Marks the view as busy (`isResponding = true`)
    /// - Appends the user’s input as a message to be shown on tthe ChatView
    /// - Sends the finalized prompt to the model
    /// - Awaits and appends the model’s response, or an error message if the request fails
    /// - Resets the state to indicate the response cycle has finished
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
