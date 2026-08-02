---
status: implemented
area: model-generation
platforms:
  - ios-26
  - ios-27
---

# Session Prewarming

## Purpose

Prepare the initial language-model session early to reduce perceived startup work when the first prompt is sent.

## User Story

As a user, I want the first response to begin promptly so that starting a new chat feels responsive.

## Acceptance Criteria

- The initial model session is prepared when the chat model is created.
- Prewarming does not send a prompt or add a visible chat message.
- Prewarming remains fully on-device and does not require a network request.
