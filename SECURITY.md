# Security Policy

## Supported Versions

Security fixes are applied to the latest published Localight release.

Localight is a demonstration app for iOS 26 and iOS 27 using Apple's on-device Foundation Models framework. It is not production-ready, and older demo builds are not maintained.

## System and Scope

This policy covers the Localight app source, bundled resources, and Xcode project configuration in this repository. Localight has no app backend, account system, remote inference service, analytics, telemetry, or persistent chat store. The operating system provides and manages the on-device language model and photo-picker access.

Security-sensitive assets include user prompts, generated responses, selected image attachments, local files and photo-library data, signing material, credentials, and build artifacts that could contain private developer or user data.

## Threat Model and Trust Boundaries

Treat prompt text, model output, selected images, image metadata, imported attachment data, and framework errors as untrusted input. Model output is fallible and must not be treated as trusted instructions or executable content.

The important boundaries are between Localight and:

- the system-provided Foundation Models framework;
- the system photo picker and the single image explicitly selected by the user;
- the app's in-memory chat state; and
- repository and build configuration, which must not introduce remote services or expose sensitive local material.

Localight does not claim to protect data from a compromised device, operating system, Xcode installation, or Apple framework. Availability and safety behavior enforced inside Foundation Models are platform dependencies, not controls implemented by this app.

## Security Invariants

- Prompt and response generation remains on-device through `SystemLanguageModel.default`; the app must not add network transmission, cloud inference, remote fallback, analytics, or telemetry.
- Chats and attachments remain in memory only and are not restored after relaunch.
- The app may access only the single image a user explicitly selects through the system photo picker. The selected attachment is released after sending, removal, or session reset.
- User prompts, attachments, model output, framework errors, and private device data must not be written to logs or bundled into build artifacts.
- Credentials, signing identities, provisioning profiles, private keys, personal data, and generated app bundles must not be committed to the repository.
- Model and framework failures must be presented safely; raw or model-generated content must not become executable instructions or silently trigger privileged actions.
- iOS 27-only APIs remain compile-time guarded, and runtime selection preserves the iOS 26 fallback without raising the iOS 26 deployment target.

## Reportable Findings and Severity Context

Please report vulnerabilities that violate these boundaries or invariants, including:

- unintended network access, data transmission, telemetry, or persistence;
- unauthorized access to photos, local files, prompts, responses, or other device data;
- exposure of sensitive data through logs, UI, repository contents, build configuration, or bundled artifacts;
- processing that escapes the one-image, user-selected attachment boundary;
- executable or privileged behavior triggered by untrusted prompts, images, model output, or framework errors; and
- build or availability-guard defects that expose sensitive functionality or defeat the supported iOS 26 fallback.

Assess severity from realistic reachability and impact. A locally reproducible demo-app crash or incorrect model response is not high severity by itself. Unauthorized disclosure or transmission of private user data, committed credentials, or code execution across a trust boundary is materially more severe.

## Out of Scope and Known Limitations

Unless they cause a security or privacy impact described above, the following are not security vulnerabilities:

- inaccurate, incomplete, misleading, refused, or otherwise low-quality model responses;
- prompt injection that only influences the current model response and does not cross an app or device trust boundary;
- unsupported devices, unavailable models, language or locale limitations, context-window exhaustion, rate limits, and timeouts;
- general UI, accessibility, performance, or compatibility bugs; and
- loss of chat history when the app exits, because non-persistence is intentional.

Localight is a showcase without production controls such as accounts, authorization, moderation workflows, encrypted persistent storage, or a service-side security boundary. These absent features are not vulnerabilities unless a change claims to provide them or their absence causes a separate violation of the invariants above.

## Reporting a Vulnerability

Please do not disclose vulnerabilities in a public issue or pull request.

Use GitHub's private vulnerability reporting for this repository from the **Security** tab by choosing **Report a vulnerability**. Include the affected version, steps to reproduce, realistic impact, and any suggested fix.

If **Report a vulnerability** is not visible, open a public issue asking for a private contact channel without including vulnerability details.

Do not include private prompts, credentials, personal data, or sensitive screenshots unless they are strictly required to explain the issue. Redact anything that is not needed to reproduce the problem.
