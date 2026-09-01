---
status: implemented
area: model-usage
platforms:
  - ios-27
---

# Current Context Usage

## Purpose

Show how much of the current language-model session’s context window has been consumed.

## User Story

As a user, I want to see current context usage so that I can understand how close the chat is to the model’s limit.

## Acceptance Criteria

- Settings show used tokens relative to the model’s context-window size.
- Usage includes the active system instructions and updates from framework-reported session usage after responses.
- Starting a fresh session resets displayed usage to the token count of the active instructions.

## iOS 26 behavior

Live context usage is an iOS 27 feature. On iOS 26, settings show only the model’s maximum context size in tokens, without a used-token count or progress indicator.
