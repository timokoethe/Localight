---
status: implemented
area: model-usage
platforms:
  - ios-27
---

# Per-Message Token Usage

## Purpose

Make the token cost of individual user prompts and model responses visible within the chat.

## User Story

As a user, I want to see token usage per message so that I can understand how each exchange consumes context.

## Acceptance Criteria

- A setting lets the user show or hide token counts beneath chat messages.
- User messages display text-prompt token counts and completed model messages display output-token counts when available.
- Token values come from Foundation Models framework APIs rather than text-length estimates; image-token contribution is not reported separately.
