import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:simple_chat/app/models/chat.dart';

class ChatRepository {
  @visibleForTesting
  final List<Chat> chats = [];
  final _streamController = StreamController<List<Chat>>.broadcast();
  Stream<List<Chat>> get chatsStream => _streamController.stream;
  void send(Chat chat) {
    chats.add(chat);
    _streamController.add(chats);
  }
}
