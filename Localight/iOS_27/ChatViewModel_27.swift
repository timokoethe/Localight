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
    private var accumulatedInputTokens = 0
    private var accumulatedOutputTokens = 0

    var instructions: String
    var instructionsDraft: String
    var temperature: Double
    var temperatureDraft: Double
    let contextSize: Int
    var contextTokensUsed: Int
    var inputText: String
    var prompt: String
    var isResponding: Bool
    var isStreaming: Bool
    var showsMessageTokenUsage: Bool
    var messages: [Message_27]
    var streamingResponse: String

    var hasInstructionChanges: Bool {
        let trimmed = instructionsDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && trimmed != instructions
    }

    var hasTemperatureChanges: Bool {
        temperatureDraft != temperature
    }

    init() {
        let defaultInstructions = "Act as the best buddie. Keep your answer short."
        self.session = LanguageModelSession(instructions: defaultInstructions)
        self.options = GenerationOptions(temperature: 1.0)
        self.instructions = defaultInstructions
        self.instructionsDraft = defaultInstructions
        self.temperature = 1.0
        self.temperatureDraft = 1.0
        self.contextSize = SystemLanguageModel.default.contextSize
        self.contextTokensUsed = 0
        self.inputText = ""
        self.prompt = ""
        self.isResponding = false
        self.isStreaming = false
        self.showsMessageTokenUsage = true
        self.messages = []
        self.streamingResponse = ""
        self.session.prewarm()
        if #available(iOS 27.0, *) {
            Task {
                await updateInstructionTokenCount()
            }
        }
    }

    func getResponse() async {
        await preparePrompt()
        var modelMessageIndex: Int?
        do {
            let response = try await session.respond(to: prompt, options: options)
            messages.append(Message_27(text: response.content, sender: .model))
            modelMessageIndex = messages.index(before: messages.endIndex)
        } catch {
            messages.append(Message_27(text: error.localizedDescription, sender: .model))
        }
        isResponding = false
        if #available(iOS 27.0, *) {
            updateTokenUsage(for: modelMessageIndex)
        }
    }

    func streamResponse() async {
        await preparePrompt()
        let stream = session.streamResponse(to: prompt, options: options)
        var modelMessageIndex: Int?
        do {
            for try await chunk in stream {
                streamingResponse = chunk.content
            }

            let response = try await stream.collect()
            messages.append(Message_27(text: response.content, sender: .model))
            modelMessageIndex = messages.index(before: messages.endIndex)
        } catch {
            messages.append(Message_27(text: error.localizedDescription, sender: .model))
        }
        streamingResponse = ""
        isResponding = false
        if #available(iOS 27.0, *) {
            updateTokenUsage(for: modelMessageIndex)
        }
    }

    func applyInstructions() {
        let trimmed = instructionsDraft.trimmingCharacters(in: .whitespacesAndNewlines)
        instructions = trimmed
        instructionsDraft = trimmed
        resetSession()
    }

    func applyTemperature() {
        temperature = temperatureDraft
        resetSession()
    }

    func resetSession() {
        session = LanguageModelSession(instructions: instructions)
        options = GenerationOptions(temperature: temperature)
        inputText = ""
        prompt = ""
        isResponding = false
        isStreaming = false
        messages = []
        streamingResponse = ""
        contextTokensUsed = 0
        accumulatedInputTokens = 0
        accumulatedOutputTokens = 0
        if #available(iOS 27.0, *) {
            Task {
                await updateInstructionTokenCount()
            }
        }
    }

    private func preparePrompt() async {
        isResponding = true
        messages.append(Message_27(text: inputText, sender: .user))
        let messageIndex = messages.index(before: messages.endIndex)
        prompt = inputText
        inputText = ""

        if #available(iOS 27.0, *) {
            messages[messageIndex].tokenCount = try? await SystemLanguageModel.default.tokenCount(
                for: prompt
            )
        }
    }

    @available(iOS 27.0, *)
    private func updateInstructionTokenCount() async {
        let tokenCount = try? await SystemLanguageModel.default.tokenCount(
            for: Instructions(instructions)
        )
        if messages.isEmpty {
            contextTokensUsed = tokenCount ?? 0
        }
    }

    @available(iOS 27.0, *)
    private func updateTokenUsage(for messageIndex: Int?) {
        updateTokenUsage(for: messageIndex, using: session.usage)
    }

    @available(iOS 27.0, *)
    private func updateTokenUsage(
        for messageIndex: Int?,
        using usage: LanguageModelSession.Usage
    ) {
        let inputTokens = usage.input.totalTokenCount
        let outputTokens = usage.output.totalTokenCount

        let newInputTokens = inputTokens - accumulatedInputTokens
        let newOutputTokens = outputTokens - accumulatedOutputTokens
        accumulatedInputTokens = inputTokens
        accumulatedOutputTokens = outputTokens

        guard newInputTokens + newOutputTokens > 0 else {
            return
        }

        contextTokensUsed = newInputTokens + newOutputTokens
        if let messageIndex {
            messages[messageIndex].tokenCount = newOutputTokens
        }
    }
}
