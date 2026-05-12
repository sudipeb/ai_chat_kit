import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  /// Copies the provided text to the clipboard and shows a snackbar.
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final message = widget.messages[widget.messages.length - 1 - index];
                final isUser = message.role == MessageRole.user;

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: GestureDetector(
                    onLongPress: () => _copyToClipboard(message.text),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.blue[100] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(message.text),
                    ),
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
    );
  }
}
