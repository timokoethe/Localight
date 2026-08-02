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
