import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_chat/app/pages/chat_page.dart';
import 'package:simple_chat/app/repositories/chat_repository.dart';
import 'package:simple_chat/app/services/chat_service.dart';

import 'app/models/chat.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final repository = ChatRepository();
  final service = ChatService()..connect();
  StreamSubscription? sendingSubscription;
  StreamSubscription? receiveSubscription;

  @override
  void initState() {
    super.initState();
    sendingSubscription = repository.onSend((newChat) {
      service.send(newChat);
    });
    receiveSubscription = service.newChatStream.listen((newChat) {
      repository.receive(Chat(newChat));
    });
  }

  @override
  void dispose() async {
    service.close();
    sendingSubscription?.cancel();
    receiveSubscription?.cancel();
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
