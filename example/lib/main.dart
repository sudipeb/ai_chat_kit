import 'package:flutter/material.dart';
import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'mock_provider.dart';

void main() {
  // Enable internal package logging to see state transitions in the console
  AIChat.enableStateLogging();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat Kit Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ChatExampleScreen(),
    );
  }
}

class ChatExampleScreen extends StatefulWidget {
  const ChatExampleScreen({super.key});

  @override
  State<ChatExampleScreen> createState() => _ChatExampleScreenState();
}

class _ChatExampleScreenState extends State<ChatExampleScreen> {
  late final AIModelProvider _provider;
  final String _model = 'mock-gpt-4';

  @override
  void initState() {
    super.initState();
    // In a real app, you might initialize OpenAIProvider, GeminiProvider, etc.
    // final provider = OpenAIProvider(apiKey: 'your-key');
    _provider = MockAIProvider();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit(
        provider: _provider,
        model: _model,
      ),
      child: const ChatPage(),
    );
  }
}
