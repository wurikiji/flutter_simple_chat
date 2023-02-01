import 'dart:async';

import 'package:simple_chat/app/models/chat.dart';
import 'package:simple_chat/app/repositories/chat_repository.dart';
import 'package:simple_chat/app/services/chat_service.dart';

class ConnectedChatRepository extends ChatRepository {
  final ChatService service;
  late StreamSubscription _subs;

  ConnectedChatRepository(this.service) {
    _subs = service.newChatStream.listen((chat) {
      super.send(Chat(chat));
    });
  }

  @override
  void send(chat) {
    super.send(chat);
    service.send(chat);
  }

  Future dispose() {
    _subs.cancel();
    return service.close();
  }
}
