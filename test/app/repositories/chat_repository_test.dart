import 'package:flutter_test/flutter_test.dart';
import 'package:simple_chat/app/models/chat.dart';
import 'package:simple_chat/app/repositories/chat_repository.dart';

void main() {
  group('Chat', () {
    test('has a message', () {
      const chat = Chat('message');
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
      const chat = Chat('message');
      chatRepository.send(chat);
      expect(chatRepository.chats, contains(chat));
    });

    test('can notify when a new chat is sent', () async {
      const chat = Chat('message');
      final chatStream = chatRepository.chatsStream;
      final result = expectLater(chatStream, emits(contains(chat)));
      chatRepository.send(chat);
      await result;
    });
  });
}
