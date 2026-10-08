---
status: implemented
area: multimodal-input
platforms:
  - ios-27
---

# Single-Image Attachments

## Purpose

Demonstrate multimodal prompting by allowing one local image to accompany a text prompt.

## User Story

As a user, I want to attach an image so that I can ask the on-device model about its contents.

## Acceptance Criteria

- The composer accepts at most one image selected from the photo picker and shows a removable preview.
- While an image is loading, sending, clearing the chat, and opening settings are unavailable. These controls become available again after the import finishes, subject to their normal conditions.
- Only the latest image import can update the attachment or release the loading lock, including when the same photo is selected again.
- An image is only sent together with a text prompt; sending stays unavailable while the text field is empty.
- The selected attachment is released after sending, removing it, or resetting the session and is never persisted or uploaded.
