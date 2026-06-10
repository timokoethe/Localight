//
//  ChatViewModel_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import Foundation
import FoundationModels

/// Manages the iOS 27 chat state and language model session.
@Observable class ChatViewModel_27 {
    private var session: LanguageModelSession
    private var options: GenerationOptions

    var instructions: String
    var instructionsDraft: String
    var temperature: Double
    let contextSize: Int
    var samplingMode: GenerationOptions.SamplingMode
    var inputText: String
    var prompt: String
    var isResponding: Bool
    var isStreaming: Bool
    var messages: [Message_27]
    var streamingResponse: String

    var hasInstructionChanges: Bool {
        let trimmed = instructionsDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed != instructions
    }

    init() {
        let defaultInstructions = "Act as the best buddie. Keep your answer short."
        self.session = LanguageModelSession(instructions: defaultInstructions)
        self.options = GenerationOptions(samplingMode: .greedy, temperature: 2.0)
        self.instructions = defaultInstructions
        self.instructionsDraft = defaultInstructions
        self.temperature = 2.0
        self.contextSize = SystemLanguageModel.default.contextSize
        self.samplingMode = .greedy
        self.inputText = ""
        self.prompt = ""
        self.isResponding = false
        self.isStreaming = false
        self.messages = []
        self.streamingResponse = ""
    }

    func getResponse() async {
        isResponding = true
        messages.append(Message_27(text: inputText, sender: .user))
        prompt = inputText
        inputText = ""
        do {
            let response = try await session.respond(to: prompt)
            messages.append(Message_27(text: response.content, sender: .model))
        } catch {
            messages.append(Message_27(text: error.localizedDescription, sender: .model))
        }
        isResponding = false
    }

    func streamResponse() async {
        isResponding = true
        messages.append(Message_27(text: inputText, sender: .user))
        prompt = inputText
        inputText = ""
        let stream = session.streamResponse(to: prompt)
        do {
            for try await chunk in stream {
                streamingResponse = chunk.content
            }

            let response = try await stream.collect()
            messages.append(Message_27(text: response.content, sender: .model))
        } catch {
            messages.append(Message_27(text: error.localizedDescription, sender: .model))
        }
        streamingResponse = ""
        isResponding = false
    }

    func applyInstructions() {
        let trimmed = instructionsDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        instructions = trimmed
        instructionsDraft = trimmed
        resetSession()
    }

    func resetSession() {
        session = LanguageModelSession(instructions: instructions)
        options = GenerationOptions(samplingMode: .greedy, temperature: temperature)
        inputText = ""
        prompt = ""
        isResponding = false
        isStreaming = false
        messages = []
        streamingResponse = ""
    }
}
