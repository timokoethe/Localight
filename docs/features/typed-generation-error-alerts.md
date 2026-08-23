---
status: implemented
area: error-handling
platforms:
  - ios-27
---

# Typed Generation Error Alerts

## Purpose

Explain generation failures with clear, safe messages that help users decide what to do next.

## User Story

As a user, I want understandable generation-error alerts so that I can recover without interpreting raw framework errors.

## Acceptance Criteria

- Generation failures are presented in an alert and do not remain as model-authored chat messages.
- Known language-model failures receive specific titles and guidance, including context, rate-limit, timeout, refusal, safety, language, and unsupported-content errors.
- The active-response state is cleared after either successful generation or failure.

## iOS 26 behavior

Typed error alerts are an iOS 27 feature. On iOS 26 there is no typed alert mapping:

- Generation failures are surfaced as a chat message using the model sender style, but its content is the system-provided error description (`localizedDescription`) rather than model-authored text.
- The active-response state is still cleared after either successful generation or failure.
