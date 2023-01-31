import 'package:grpc_chat/gprc_chat.dart';
import 'package:simple_chat/app/models/chat.dart';
import 'package:simple_chat/app/repositories/chat_repository.dart';

class ChatService with OnSend {
  final chatServer = ChatClient();
  bool isConnected = false;

  late Stream<String> newChatStream;

  Future<void> connect() async {
    final originalStream = chatServer.connect();
    newChatStream = originalStream.map((event) => event.text);
    isConnected = true;
  }

  bool send(Chat chat) {
    chatServer.send(chat.message);
    return true;
  }

  close() async {
    await chatServer.close();
  }

  @override
  void Function(Chat newChat) get onSend => (chat) {
        send(chat);
      };
}
