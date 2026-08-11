---
status: implemented
area: chat
platforms:
  - ios-26
  - ios-27
---

# Markdown Model Responses

## Purpose

Make common Markdown formatting in model output easier to read while keeping the chat interface native and lightweight.

## User Story

As a user, I want model responses to display common Markdown formatting so that emphasis, inline code, and links are readable without showing their formatting markers.

## Acceptance Criteria

- Completed and streaming model responses render bold and italic emphasis, inline code, and links on iOS 26 and iOS 27.
- Model response line breaks remain visible after Markdown parsing.
- The same Markdown syntax in a user message is displayed literally.
- A parsing failure displays the original response as plain text.
- Markdown parsing happens entirely on-device without a network request or third-party dependency.
- Styled headings, lists, tables, and fenced code blocks are not supported as block-level presentation.
- Streaming output may temporarily show Markdown delimiters until the model completes the corresponding syntax.
