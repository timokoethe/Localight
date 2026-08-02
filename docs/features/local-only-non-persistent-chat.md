---
status: implemented
area: privacy
platforms:
  - ios-26
  - ios-27
---

# Local-Only, Non-Persistent Chat

## Purpose

Keep the showcase private and temporary by retaining conversations only for the lifetime of the active app session.

## User Story

As a user, I want my chat to remain local and temporary so that it is not uploaded or restored after relaunching the app.

## Acceptance Criteria

- Chat messages and attachments are held in memory only and are not written to persistent storage.
- Relaunching the app starts with an empty chat and does not restore previous prompts or responses.
- The app does not send conversations, attachments, analytics, or telemetry to a remote service.
