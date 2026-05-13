## 0.1.0

* **Streaming Support**: Added full support for interactive, dynamic responses (typewriter effect).
* **AI Providers**: Implemented streaming for OpenAI, Gemini, and Claude.
* **BLoC Enhancement**: Added `ChatStreaming` state to `ChatCubit` for incremental UI updates.
* **UI Improvements**: Updated `SimplexChatView` to handle real-time content updates with smoother text normalization.
* **API Extension**: Added `streamMessage` to `AIModelProvider` and a new `stream()` method to the high-level `AIChat` class.

## 0.0.1

* Initial release with support for OpenAI, Gemini, and Claude (non-streaming).
* BLoC-based state management and basic Simplex UI components.
