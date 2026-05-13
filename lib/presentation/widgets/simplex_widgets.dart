import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/logger/ai_chat_logger.dart';
import '../../core/models/chat_message.dart';

/// A base class for views that use a BLoC/Cubit.
abstract class SimplexBlocView<B extends StateStreamableSource<S>, S> extends StatelessWidget {
  const SimplexBlocView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      builder: (context, state) {
        return buildWidget(context, context.read<B>(), state);
      },
    );
  }

  /// Override this method to build the UI based on the [bloc] and [state].
  Widget buildWidget(BuildContext context, B bloc, S state);
}

/// A reusable chat interface component.
///
/// Provides a message list view, message bubble styling, and a text input field
/// for sending new messages. Handles user interaction and message dispatching.
class SimplexChatView extends StatefulWidget {
  /// The list of chat messages to display.
  final List<ChatMessage> messages;

  /// Callback function triggered when a user sends a message.
  final void Function(String) onSend;

  /// Whether the UI should show a loading indicator.
  final bool isLoading;

  /// Whether the UI is currently receiving a streamed response.
  final bool isStreaming;

  /// Optional error message to display in the chat UI.
  final String? error;

  /// Optional callback function triggered when a user clears the chat.
  final VoidCallback? onClear;

  const SimplexChatView({
    super.key,
    required this.messages,
    required this.onSend,
    this.onClear,
    this.isLoading = false,
    this.isStreaming = false,
    this.error,
  });

  @override
  State<SimplexChatView> createState() => _SimplexChatViewState();
}

class _SimplexChatViewState extends State<SimplexChatView> {
  final TextEditingController _controller = TextEditingController();
  String _lastLoggedText = '';
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    AIChatLogger.log('Chat view initialized');
  }

  @override
  void dispose() {
    AIChatLogger.log('Chat view disposed');
    _controller.dispose();
    super.dispose();
  }

  /// Handles text input changes and logs typing events.
  void _onTextChanged(String text) {
    final trimmedText = text.trim();
    final hasTextNow = trimmedText.isNotEmpty;

    // Update button state
    if (_hasText != hasTextNow) {
      setState(() => _hasText = hasTextNow);
      AIChatLogger.log('Send button ${_hasText ? 'enabled' : 'disabled'} (${trimmedText.length} characters)');
    }

    final lastTrimmedText = _lastLoggedText.trim();

    // Log when user starts typing
    if (_lastLoggedText.isEmpty && trimmedText.isNotEmpty) {
      AIChatLogger.log('User started typing');
    }
    // Log when user clears input
    else if (_lastLoggedText.isNotEmpty && trimmedText.isEmpty) {
      AIChatLogger.log('User cleared input');
    }
    // Log significant text changes (every 10 characters or when hitting word boundaries)
    else if (trimmedText.isNotEmpty && (trimmedText.length - lastTrimmedText.length).abs() >= 10) {
      AIChatLogger.log('User typing: "${trimmedText.length} characters"');
      _lastLoggedText = text;
    }
    // Log when user hits enter/space (potential message completion)
    else if (text.endsWith('\n') || text.endsWith(' ')) {
      _lastLoggedText = text;
    }
  }

  /// Dispatches the current text input and clears the controller.
  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      AIChatLogger.log('Send button pressed with message: "${text.length} characters"');
      widget.onSend(text);
      _controller.clear();
      _lastLoggedText = '';
      setState(() => _hasText = false);
      AIChatLogger.log('Input cleared after sending');
    } else {
      AIChatLogger.log('Send button pressed but input was empty (unexpected)');
    }
  }

  /// Normalizes the AI message text by removing markdown headers, bolding, and extra spacing.
  String _normalizeText(String text) {
    // Remove markdown headers (e.g., #, ##)
    String normalized = text.replaceAll(RegExp(r'^#+\s+', multiLine: true), '');
    // Remove markdown bolding (e.g., **text**)
    normalized = normalized.replaceAllMapped(RegExp(r'\*\*([^*]+)\*\*'), (match) {
      return match.group(1) ?? '';
    });
    // Replace markdown list markers (*, -) with a bullet dot (•)
    normalized = normalized.replaceAll(RegExp(r'^\s*[\*\-]\s+', multiLine: true), '• ');
    // Clean up excessive newlines (3 or more) but keep single and double newlines
    normalized = normalized.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    // For streaming, we want to avoid trimming trailing whitespace as it might be
    // part of the next chunk (e.g., a space before the next word).
    // We only trim the start.
    return normalized.replaceFirst(RegExp(r'^\s+'), '');
  }

  @override
  Widget build(BuildContext context) {
    AIChatLogger.log(
      'Chat view rebuilding: ${widget.messages.length} messages, loading: ${widget.isLoading}, error: ${widget.error != null}',
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Assistant'),
        centerTitle: true,
        actions: [
          if (widget.onClear != null && widget.messages.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear Chat',
              onPressed: widget.onClear,
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth > 800 ? 800.0 : constraints.maxWidth;
          return Center(
            child: SizedBox(
              width: maxWidth,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      reverse: true,
                      itemCount: widget.messages.length,
                      itemBuilder: (context, index) {
                        final message = widget.messages[widget.messages.length - 1 - index];
                        final isUser = message.role == MessageRole.user;
                        final text = isUser ? message.text : _normalizeText(message.text);

                        return Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    isUser ? Icons.person_outline : Icons.smart_toy_outlined,
                                    color: Colors.grey[600],
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isUser ? 'You' : 'AI',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isUser ? Colors.blue[500] : Colors.grey[200],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(16),
                                    topRight: const Radius.circular(16),
                                    bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
                                    bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                    color: isUser ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (widget.error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(widget.error!, style: const TextStyle(color: Colors.red, fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (widget.isLoading)
                    const Padding(padding: EdgeInsets.symmetric(vertical: 8.0), child: CircularProgressIndicator()),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: _onTextChanged,
                            onSubmitted: (_) => _handleSend(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(icon: const Icon(Icons.send), onPressed: _hasText ? _handleSend : null),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
