---
status: implemented
area: model-settings
platforms:
  - ios-26
  - ios-27
---

# Adjustable Model Temperature

## Purpose

Let users control the model’s response variability within the range supported by the app.

## User Story

As a user, I want to adjust the model temperature so that I can influence how creative its responses are.

## Acceptance Criteria

- Settings provide temperature values from 0.0 through 1.0 in increments of 0.1.
- An unchanged temperature cannot be saved, and applying a change requires user confirmation.
- Saving the temperature starts a fresh model session and clears the current in-memory chat.
