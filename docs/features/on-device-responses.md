---
status: implemented
area: model-generation
platforms:
  - ios-26
  - ios-27
---

# On-Device Responses

## Purpose

Generate private language-model responses without relying on a network connection, cloud inference, or a remote service.

## User Story

As a user, I want responses to be generated on my device so that my conversation remains private and works offline.

## Acceptance Criteria

- Prompts and responses are processed with Apple’s system-provided on-device language model.
- Generating a response does not require an internet connection or send chat content to a server.
- Responses are treated as fallible and are not guaranteed to be accurate, complete, or reliable.
