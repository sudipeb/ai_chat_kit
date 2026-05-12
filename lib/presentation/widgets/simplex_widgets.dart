import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  const SimplexChatView({
    super.key,
    required this.messages,
    required this.onSend,
    this.isLoading = false,
  });

  @override
  State<SimplexChatView> createState() => _SimplexChatViewState();
}

class _SimplexChatViewState extends State<SimplexChatView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Dispatches the current text input and clears the controller.
  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
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
    // Clean up excessive newlines
    normalized = normalized.replaceAll(RegExp(r'\n{3,}'), '\n\n');
    return normalized.trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          color: isUser ? Colors.transparent : Colors.grey[100],
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                isUser ? Icons.person_outline : Icons.smart_toy_outlined,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  text,
                                  style: const TextStyle(fontSize: 16, height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (widget.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator(),
                    ),
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
                            onSubmitted: (_) => _handleSend(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _handleSend,
                        ),
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
