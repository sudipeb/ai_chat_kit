import 'package:flutter/material.dart';
import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Kit Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ChatExampleScreen(),
    );
  }
}

/// A mock AI provider for demonstration purposes.
class MockAIProvider implements AIModelProvider {
  @override
  Future<String> sendMessage({
    required String prompt,
    required List<ChatMessage> history,
    Map<String, dynamic>? options,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    if (prompt.toLowerCase().contains('hello')) {
      return 'Hello! I am a mock AI. How can I help you today?';
    } else if (prompt.toLowerCase().contains('who are you')) {
      return 'I am the AI Chat Kit demo provider.';
    } else {
      return 'You said: "$prompt". This is a response from the mock AI.';
    }
  }

  @override
  String get modelName => "mock-ai-model";
}

class ChatExampleScreen extends StatelessWidget {
  const ChatExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat Kit Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocProvider(
        create: (context) => ChatCubit(MockAIProvider()),
        child: const ChatPage(),
      ),
    );
  }
}
