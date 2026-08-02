---
status: implemented
area: chat-lifecycle
platforms:
  - ios-26
  - ios-27
---

# Clear Chat Session

## Purpose

Let users discard the current conversation and continue with a fresh language-model session.

## User Story

As a user, I want to clear the current chat so that I can begin a new conversation without prior context.

## Acceptance Criteria

- A Clear control is available when the chat contains messages and no response is active.
- Clearing creates a fresh session with the active instructions and temperature and removes all visible messages and draft input.
- On iOS 27, clearing also releases any selected image, resets context usage, and dismisses generation-error state.
