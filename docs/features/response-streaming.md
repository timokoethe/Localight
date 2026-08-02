---
status: implemented
area: model-generation
platforms:
  - ios-26
  - ios-27
---

# Response Streaming

## Purpose

Let users see a model response as it is generated instead of waiting for the complete result.

## User Story

As a user, I want to choose whether responses stream so that I can read them progressively or receive them all at once.

## Acceptance Criteria

- A setting lets the user enable or disable response streaming.
- When streaming is enabled, partial model output is shown until the final response is complete.
- Sending, clearing, and opening settings are unavailable while a response is active.
