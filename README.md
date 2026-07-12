# Localight for iOS

[![License: MIT](https://img.shields.io/badge/license-MIT-orange)](https://opensource.org/license/mit)
![Framework](https://img.shields.io/badge/SwiftUI-orange)
![Platform](https://img.shields.io/badge/Platforms-iOS-orange)
![Xcode](https://img.shields.io/badge/Xcode-26+27-orange)
![iOS](https://img.shields.io/badge/iOS-26+27-orange)
![Apple](https://img.shields.io/badge/Apple-000000?style=flat&logo=apple)

**Localight** is a native SwiftUI chat app for iOS 26 and iOS 27, powered entirely by Apple’s on-device Foundation Models. Designed as a practical demonstration, Localight provides fast, private, and fully offline AI chat — no internet connection or server required.

Localight showcases how to integrate Apple’s on-device language model into a native iOS experience using SwiftUI and the [Foundation Models](https://developer.apple.com/documentation/foundationmodels) framework.

> [!WARNING]
> Localight is a demonstration app and is not production-ready. Model output may be inaccurate, incomplete, or misleading.

## Apple Foundation Models

Apple’s third-generation model family contains five models: two on-device models and three server-based models running on [Private Cloud Compute](https://security.apple.com/blog/private-cloud-compute).
The local models are **AFM 3 Core**, a dense 3-billion-parameter model, and **AFM 3 Core Advanced**, a multimodal 20-billion-parameter sparse model that activates 1–4 billion parameters depending on the request.
The server models are **AFM 3 Cloud**, **ADM 3 Cloud (Image)**, and **AFM 3 Cloud Pro**.

Localight accesses the system-provided on-device model through `SystemLanguageModel`.
Availability depends on the device and operating system.
See [Introducing the Third Generation of Apple’s Foundation Models](https://machinelearning.apple.com/research/introducing-third-generation-of-apple-foundation-models) for details.

## ✨ Features

- 🧠 **On-device model**: Uses Apple’s local Foundation Models for text generation.
- 🔐 **Privacy-first**: All conversations stay on your device. No data is sent to the cloud.
- ⚡ **Fast and offline**: No internet connection is required. Responses are generated locally.
- 💬 **Minimalist chat UI**: Provides a clean SwiftUI interface for interacting with the model.
- 🗑️ **No history**: Conversations are not saved after closing the app.

### Feature Matrix

| Feature | iOS 26 | iOS 27 |
| --- | :---: | :---: |
| On-device responses | ✅ | ✅ |
| Response streaming | ✅ | ✅ |
| Session prewarming | ✅ | ✅ |
| Editable model instructions | ✅ | ✅ |
| Adjustable model temperature | ✅ | ✅ |
| Current context usage | ❌ | ✅ |
| Per-message token usage | ❌ | ✅ |
| Single-image attachments | ❌ | ✅ |
| Typed generation error alerts | ❌ | ✅ |
| Model availability fallback | ✅ | ✅ |
| Clear chat session | ✅ | ✅ |
| Local-only, non-persistent chat | ✅ | ✅ |

## 📁 Project Structure

Localight keeps separate implementations for each supported iOS version:

```text
Localight/
├── ContentView_26.swift
├── ContentView_27.swift
├── iOS_26/              # iOS 26 chat, model, settings, and components
├── iOS_27/              # iOS 27 chat, model, settings, and components
└── LocalightApp.swift   # Selects the implementation for the current iOS version
```

Version-specific files and types use the `_26` or `_27` suffix.

### SDK and deployment behavior

The deployment target remains iOS 26, so a single app built with the iOS 27 SDK can run on both supported system versions. The project separates SDK availability from runtime availability:

- Builds using an iOS 26 SDK compile only the iOS 26 implementation. This keeps the project buildable even though that SDK does not contain the newer Foundation Models APIs.
- Builds using an iOS 27 SDK automatically define `LOCALIGHT_IOS27_SDK` and compile both implementations.
- At runtime, `LocalightApp` uses `#available(iOS 27.0, *)` to select the iOS 27 implementation while retaining the iOS 26 fallback.

The SDK-specific compilation conditions currently match iOS 27.x. When adopting a later major SDK, update the conditional `SWIFT_ACTIVE_COMPILATION_CONDITIONS` entries in the target build settings so the iOS 27 implementation remains enabled.

## 🛠 How it works

- **Import the framework**: Import `FoundationModels` in every file that uses its APIs:

    ```swift
    import FoundationModels
    ```

- **Check availability**: Use [SystemLanguageModel](https://developer.apple.com/documentation/foundationmodels/systemlanguagemodel) to determine whether the model is `.available` or `.unavailable`. When unavailable, the framework also provides a reason.

- **Create a session**: Initialize a [LanguageModelSession](https://developer.apple.com/documentation/foundationmodels/languagemodelsession). Its instructions define the model’s role and response behavior:

    ```swift
    let session = LanguageModelSession(
        instructions: "Act like a helpful friend. Keep your answers concise."
    )
    ```

- **Generate a response**: Call `respond(to:)` to generate a complete response:

    ```swift
    let response = try await session.respond(to: promptAsString).content
    ```

- **Stream a response**: Use `streamResponse(to:)` to display content as it is generated:

    ```swift
    let stream = session.streamResponse(to: promptAsString)

    do {
        for try await chunk in stream {
            self.streamingResponse = chunk.content
        }

        let response = try await stream.collect().content
    } catch {
        handleGenerationError(error)
    }
    ```

- **Handle generation errors**: On iOS 27, Localight maps `LanguageModelError` cases such as context-size, rate-limit, timeout, refusal, guardrail, and unsupported-content failures to user-facing alerts instead of adding raw framework errors to the chat.

## 📏 Context Window & Token Limits

Apple’s on-device Foundation Models operate with a limited context window per session.
The context window defines how many tokens the model can process within a single `LanguageModelSession`.
On iOS 27, the displayed usage includes the system instructions.

- A token is a unit of text processed by the model.
- In Western languages (e.g. English or German), 1 token ≈ 3–4 characters.
- In East Asian languages (e.g. Japanese or Chinese), 1 token ≈ 1 character.
- The system model currently supports up to **4,096 tokens** per session.

If this limit is exceeded, the framework throws the following error: `LanguageModelError.contextSizeExceeded(_:)`

For more details, see Apple’s official documentation:
[TN3193 – Managing the on-device foundation model’s context window](https://developer.apple.com/documentation/technotes/tn3193-managing-the-on-device-foundation-model-s-context-window)

## License

Localight is available under the MIT License. See [LICENSE](LICENSE) for the full license text.
