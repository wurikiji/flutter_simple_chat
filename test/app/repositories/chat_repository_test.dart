import 'package:flutter_test/flutter_test.dart';
import 'package:simple_chat/app/models/chat.dart';
import 'package:simple_chat/app/repositories/chat_repository.dart';

void main() {
  group('Chat', () {
    test('has a sender and a message', () {
      const chat = Chat('sender', 'message');
      expect(chat.sender, equals('sender'));
      expect(chat.message, equals('message'));
    });
  });

  group('Chat Repository', () {
    late ChatRepository chatRepository;
    setUp(() => chatRepository = ChatRepository());
    test('created with an empty chat list', () {
      expect(chatRepository.chats, isEmpty);
      expect(chatRepository.chats, isA<List<Chat>>());
    });

    test('can send a new chat', () {
      const chat = Chat('sender', 'message');
      chatRepository.send(chat);
      expect(chatRepository.chats, contains(chat));
    });

    test('can notify when a new chat is sent', () async {
      const chat = Chat('sender', 'message');
      final chatStream = chatRepository.chatsStream;
      final result = expectLater(chatStream, emits(contains(chat)));
      chatRepository.send(chat);
      await result;
    });
  });
}
