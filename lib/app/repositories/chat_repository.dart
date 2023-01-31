import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:simple_chat/app/models/chat.dart';

class ChatRepository {
  ChatRepository({
    List<OnSend> onSendObservers = const [],
    List<OnReceive> onReceiveObservers = const [],
  }) {
    for (final observer in onSendObservers) {
      onSend(observer.onSend);
    }

    for (final observer in onReceiveObservers) {
      onReceive(observer.onReceive);
    }
  }

  @visibleForTesting
  final List<Chat> chats = [];
  final _streamController = StreamController<List<Chat>>.broadcast();
  Stream<List<Chat>> get chatsStream => _streamController.stream;

  final _onSendStreamController = StreamController<Chat>.broadcast();
  final _onReceiveStreamController = StreamController<Chat>.broadcast();

  void receive(Chat chat) {
    chats.add(chat);
    _streamController.add(chats);
    _onReceiveStreamController.add(chat);
  }

  void send(Chat chat) {
    chats.add(chat);
    _streamController.add(chats);
    _onSendStreamController.add(chat);
  }

  StreamSubscription onReceive(void Function(Chat newChat) callback) {
    return _onReceiveStreamController.stream.listen((chat) {
      callback(chat);
    });
  }

  StreamSubscription onSend(void Function(Chat newChat) callback) {
    return _onSendStreamController.stream.listen((chat) {
      callback(chat);
    });
  }
}

mixin OnSend {
  void Function(Chat newChat) get onSend;
}

mixin OnReceive {
  void Function(Chat newChat) get onReceive;
}
