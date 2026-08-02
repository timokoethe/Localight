---
status: implemented
area: model-availability
platforms:
  - ios-26
  - ios-27
---

# Model Availability Fallback

## Purpose

Prevent entry into a nonfunctional chat and clearly explain why the on-device model cannot currently be used.

## User Story

As a user, I want a clear availability message so that I understand why chat is unavailable and whether I can resolve it.

## Acceptance Criteria

- The chat is shown only when the system language model reports that it is available.
- Distinct fallback messages cover an ineligible device, disabled Apple Intelligence, and a model that is still preparing.
- Any other unavailable state produces a generic model-unavailable message without exposing unsafe technical details.
