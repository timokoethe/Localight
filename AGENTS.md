# AGENTS.md

## Project purpose

Localight is a small native SwiftUI reference app demonstrating Apple's on-device Foundation Models framework on iOS 26 and iOS 27. It is intentionally a showcase, not a production-ready chat product.

Preserve these product invariants:

- Generation stays fully on-device. Do not add network requests, cloud inference, analytics, telemetry, or remote dependencies.
- Chats and attachments remain in memory only. Do not add persistence unless the task explicitly changes that product decision.
- The app must keep an iOS 26 deployment target while also demonstrating iOS 27-only Foundation Models APIs.
- User-facing text is currently written in English.
- Treat model output as fallible and keep user-facing failures clear and safe.

When changing behavior, keep `README.md` in sync with the implementation. Update the feature matrix in particular whenever a feature is added, removed, or behaves differently between iOS 26 and iOS 27, and keep the documented SDK strategy and limitations accurate.

## Repository map

```text
Localight/
├── LocalightApp.swift          # App entry point and runtime version selection
├── ContentView_26.swift        # iOS 26 model-availability gate
├── ContentView_27.swift        # iOS 27 model-availability gate
├── iOS_26/                    # Complete iOS 26 implementation
│   ├── ChatViewModel_26.swift
│   ├── ChatView_26.swift
│   ├── SettingsView_26.swift
│   ├── Components/
│   └── Models/
├── iOS_27/                    # Complete iOS 27 implementation
│   ├── ChatViewModel_27.swift
│   ├── ChatView_27.swift
│   ├── SettingsView_27.swift
│   ├── Components/
│   └── Models/
└── Assets.xcassets/
```

The Xcode project uses a file-system-synchronized source group. Put new app source files in the appropriate directory; do not edit `project.pbxproj` merely to register them. Change the project file only for actual build-setting, target, capability, or resource-configuration work.

## Compatibility rules

This is the most important constraint in the repository.

- Types and files specific to an OS generation use the `_26` or `_27` suffix.
- Keep shared behavior aligned between both implementations unless an API or feature is intentionally version-specific.
- All code referencing iOS 27 SDK APIs must be excluded from iOS 26 SDK builds with `#if LOCALIGHT_IOS27_SDK`.
- iOS 27 declarations must also carry `@available(iOS 27.0, *)` where runtime availability requires it.
- `LocalightApp.swift` must retain both layers of selection: compile-time selection with `LOCALIGHT_IOS27_SDK` and runtime selection with `#available(iOS 27.0, *)`.
- Do not raise `IPHONEOS_DEPLOYMENT_TARGET` above 26.0 as a shortcut.
- Do not move iOS 27 API references into unguarded shared helpers. An iOS 26 SDK does not know those symbols, even when runtime availability checks exist.
- The SDK-filtered `SWIFT_ACTIVE_COMPILATION_CONDITIONS` entries in the target build settings currently match iOS 27.x. Update them deliberately when adding support for a later SDK generation.

When changing a feature that exists in both versions, inspect and update both version trees. If behavior intentionally differs, keep the README feature matrix and relevant documentation accurate.

## Architecture and state

- Root content views check `SystemLanguageModel.default.availability` before showing chat UI.
- Each chat root owns its `@Observable`, `@MainActor` view model with `@State`; child views receive it through `@Bindable`.
- `LanguageModelSession` and `GenerationOptions` belong in the view model, not in SwiftUI view bodies.
- Instructions are fixed when a session is created. Applying instructions or temperature must create a fresh session and clear session-bound chat state.
- The initial session is prewarmed in both view models. Preserve that behavior; if session-reset performance becomes relevant, evaluate prewarming replacement sessions deliberately rather than assuming it is required.
- Trim text before sending it and never submit a text-only prompt containing only whitespace.
- Keep response-state cleanup reliable on success and failure. Prefer `defer` when it makes the lifecycle unambiguous.
- UI state that is mutated by async generation remains main-actor isolated.

iOS 27 additionally supports one image attachment, token accounting, context usage, and typed `LanguageModelError` alerts. Preserve the single-image limit and release the selected attachment after sending or resetting. Token usage comes from framework APIs; do not estimate it from character counts.

## Swift and SwiftUI conventions

- Follow the style of the surrounding file rather than introducing a new architecture for a small change.
- Prefer native SwiftUI and Apple frameworks already used by the project.
- Import `FoundationModels` in every file that directly uses its APIs.
- Keep views focused on presentation and user interaction; put session and generation logic in the version-specific view model.
- Use semantic system controls, SF Symbols, Dynamic Type-compatible text, and existing asset names such as `Tint`.
- Keep controls disabled while a response is active when concurrent actions could corrupt session or message state.
- Add concise documentation for non-obvious SDK guards, availability decisions, and Foundation Models behavior. Avoid comments that merely restate the code.
- Do not add third-party packages without a clear requirement and explicit justification.

## Build and verification

There is currently one app target and scheme, both named `Localight`, and no automated test target. For code changes, at minimum build the affected configuration:

```sh
xcodebuild \
  -project Localight.xcodeproj \
  -scheme Localight \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath /tmp/localight-derived-data \
  CODE_SIGNING_ALLOWED=NO \
  build
```

For compatibility-sensitive changes, verify the complete SDK/runtime matrix when the required Xcode versions and runtimes are available:

- Build with an iOS 26 SDK. This verifies that all iOS 27 symbols and syntax are compile-time guarded.
- Build with an iOS 27 SDK and launch on iOS 26. This verifies the runtime fallback to `ContentView_26`.
- Build with an iOS 27 SDK and launch on iOS 27. This verifies the iOS 27 implementation.

Select the intended Xcode installation through `DEVELOPER_DIR`; do not assume that the machine's default Xcode covers both compile paths.

Simulator builds verify compilation, but meaningful model behavior requires an eligible environment with Apple Intelligence enabled and the system model ready. Manually exercise the affected flow when possible:

- model availability and fallback screens;
- streamed and non-streamed responses;
- clearing the chat and applying settings;
- busy and disabled-control states;
- iOS 27 attachment loading/removal, token usage, context display, and generation-error alerts when relevant;
- relaunch behavior, confirming that chat history is not persisted.

If a required SDK, runtime, or eligible device is unavailable, state that limitation in the final report rather than claiming the behavior was tested.

## Change discipline

- Keep changes narrowly scoped and preserve unrelated work in the working tree.
- Do not commit signing identities, provisioning profiles, derived data, generated app bundles, credentials, prompts, responses, photos, or other personal data.
- Update `README.md` when features, platform behavior, build conditions, privacy properties, or limitations change.
- Before finishing, run `git status --short`, `git diff --check`, and review `git diff`. Account for untracked files separately because they are not shown by `git diff`. Report exactly which build or manual checks were run.
