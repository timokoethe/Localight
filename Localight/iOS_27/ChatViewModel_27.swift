//
//  ChatViewModel_27.swift
//  Localight
//
//  Created by Timo Köthe on 10.06.26.
//

import Foundation
import FoundationModels
import UIKit

#if LOCALIGHT_IOS27_SDK
/// Manages the iOS 27 chat state and language model session.
@MainActor
@available(iOS 27.0, *)
@Observable class ChatViewModel_27 {
    private static let fallbackContextSize = 4_096

    private var session: LanguageModelSession
    private var options: GenerationOptions

    var instructions: String
    var instructionsDraft: String
    var temperature: Double
    var temperatureDraft: Double
    let contextSize: Int
    var contextTokensUsed: Int
    var inputText: String
    var attachedImage: UIImage?
    var prompt: String
    var isResponding: Bool
    var isStreaming: Bool
    var showsMessageTokenUsage: Bool
    var showsGenerationError: Bool
    var generationErrorTitle: String
    var generationErrorMessage: String
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
        let defaultInstructions = "Act as the best buddy. Keep your answer short."
        let reportedContextSize = SystemLanguageModel.default.contextSize
        self.session = LanguageModelSession(instructions: defaultInstructions)
        self.options = GenerationOptions(temperature: 1.0)
        self.instructions = defaultInstructions
        self.instructionsDraft = defaultInstructions
        self.temperature = 1.0
        self.temperatureDraft = 1.0
        // The iOS 27 beta can temporarily report zero even though the on-device
        // model has a 4,096-token context window.
        self.contextSize = reportedContextSize > 0
            ? reportedContextSize
            : Self.fallbackContextSize
        self.contextTokensUsed = 0
        self.inputText = ""
        self.attachedImage = nil
        self.prompt = ""
        self.isResponding = false
        self.isStreaming = false
        self.showsMessageTokenUsage = true
        self.showsGenerationError = false
        self.generationErrorTitle = ""
        self.generationErrorMessage = ""
        self.messages = []
        self.streamingResponse = ""
        self.session.prewarm()
        Task {
            await updateInstructionTokenCount()
        }
    }

    func getResponse() async {
        let image = await preparePrompt()
        defer {
            isResponding = false
        }

        do {
            let response = try await respond(with: image)
            messages.append(Message_27(text: response.content, sender: .model))
            let modelMessageIndex = messages.index(before: messages.endIndex)
            updateTokenUsage(for: modelMessageIndex, using: response.usage)
        } catch {
            presentGenerationError(error)
        }
    }

    func streamResponse() async {
        let image = await preparePrompt()
        let stream = responseStream(with: image)
        defer {
            streamingResponse = ""
            isResponding = false
        }

        do {
            for try await chunk in stream {
                streamingResponse = chunk.content
            }

            let response = try await stream.collect()
            messages.append(Message_27(text: response.content, sender: .model))
            let modelMessageIndex = messages.index(before: messages.endIndex)
            updateTokenUsage(for: modelMessageIndex, using: response.usage)
        } catch {
            presentGenerationError(error)
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

    func attachImageData(_ data: Data) {
        attachedImage = UIImage(data: data)
    }

    func removeAttachment() {
        attachedImage = nil
    }

    func resetSession() {
        session = LanguageModelSession(instructions: instructions)
        options = GenerationOptions(temperature: temperature)
        inputText = ""
        attachedImage = nil
        prompt = ""
        isResponding = false
        isStreaming = false
        showsGenerationError = false
        generationErrorTitle = ""
        generationErrorMessage = ""
        messages = []
        streamingResponse = ""
        contextTokensUsed = 0
        Task {
            await updateInstructionTokenCount()
        }
    }

    private func preparePrompt() async -> UIImage? {
        isResponding = true
        let image = attachedImage
        let trimmedInput = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        messages.append(Message_27(text: trimmedInput, sender: .user, image: image))
        let messageIndex = messages.index(before: messages.endIndex)
        prompt = trimmedInput.isEmpty ? "Describe this image." : trimmedInput
        inputText = ""
        attachedImage = nil

        messages[messageIndex].tokenCount = try? await SystemLanguageModel.default.tokenCount(
            for: prompt
        )

        return image
    }

    private func respond(with image: UIImage?) async throws -> LanguageModelSession.Response<String> {
        guard let cgImage = image?.cgImage else {
            return try await session.respond(to: prompt, options: options)
        }

        return try await session.respond(options: options) {
            prompt
            Attachment<ImageAttachmentContent>(cgImage)
        }
    }

    private func responseStream(with image: UIImage?) -> LanguageModelSession.ResponseStream<String> {
        guard let cgImage = image?.cgImage else {
            return session.streamResponse(to: prompt, options: options)
        }

        return session.streamResponse(options: options) {
            prompt
            Attachment<ImageAttachmentContent>(cgImage)
        }
    }

    private func presentGenerationError(_ error: Error) {
        let errorMessage = generationErrorMessage(for: error)
        generationErrorTitle = errorMessage.title
        generationErrorMessage = errorMessage.message
        showsGenerationError = true
    }

    private func generationErrorMessage(for error: Error) -> (title: String, message: String) {
        if let languageModelError = error as? LanguageModelError {
            switch languageModelError {
            case .contextSizeExceeded(_):
                return (
                    "Context window exceeded",
                    "The current chat is too long for the on-device model. Clear the chat or shorten the prompt before trying again."
                )
            case .rateLimited(_):
                return (
                    "Model is rate limited",
                    "The session is temporarily rate limited. Wait a moment, then try again."
                )
            case .refusal(_):
                return (
                    "Model refused",
                    "The model declined to answer this request."
                )
            case .timeout(_):
                return (
                    "Request timed out",
                    "The model did not finish the response in time. Try a shorter prompt or try again."
                )
            case .guardrailViolation(_):
                return (
                    "Safety guardrail triggered",
                    "The prompt or generated response triggered the model's safety guardrails."
                )
            case .unsupportedCapability(_):
                return (
                    "Unsupported capability",
                    "The current model does not support a feature required for this request."
                )
            case .unsupportedTranscriptContent(_):
                return (
                    "Unsupported content",
                    "The prompt contains content that the model cannot process."
                )
            case .unsupportedGenerationGuide(_):
                return (
                    "Unsupported generation guide",
                    "The requested structured output format is not supported by the current model."
                )
            case .unsupportedLanguageOrLocale(_):
                return (
                    "Unsupported language",
                    "The model does not support the requested language or locale."
                )
            @unknown default:
                return (
                    "Model error",
                    error.localizedDescription
                )
            }
        }

        return (
            "Response failed",
            error.localizedDescription
        )
    }

    private func updateInstructionTokenCount() async {
        let tokenCount = try? await SystemLanguageModel.default.tokenCount(
            for: Instructions(instructions)
        )
        if messages.isEmpty {
            contextTokensUsed = tokenCount ?? 0
        }
    }

    private func updateTokenUsage(
        for messageIndex: Int,
        using usage: LanguageModelSession.Usage
    ) {
        contextTokensUsed = usage.totalTokenCount
        messages[messageIndex].tokenCount = usage.output.totalTokenCount
    }
}
#endif
