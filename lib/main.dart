import 'package:flutter/material.dart';
import 'package:simple_chat/app/pages/chat_page.dart';
import 'package:simple_chat/app/repositories/connected_chat_repository.dart';
import 'package:simple_chat/app/services/chat_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final repository = ConnectedChatRepository(ChatService());

  @override
  void dispose() async {
    await repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: ChatPage(repository),
    );
  }
}
