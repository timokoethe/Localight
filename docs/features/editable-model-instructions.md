---
status: implemented
area: model-settings
platforms:
  - ios-26
  - ios-27
---

# Editable Model Instructions

## Purpose

Let users change the system instructions that guide the model’s behavior and tone.

## User Story

As a user, I want to edit the model instructions so that responses better match my preferred behavior and tone.

## Acceptance Criteria

- Settings provide a multiline field containing the current model instructions.
- Only a changed, non-empty instruction value can be saved, after user confirmation.
- Saving instructions starts a fresh model session and clears the current in-memory chat.
