import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:simple_chat/app/models/chat.dart';
import 'package:simple_chat/app/repositories/chat_repository.dart';

class ChatRepositoryTester {
  ChatRepositoryTester(this.creator, this.testName);
  final ChatRepository Function() creator;
  final String testName;

  @isTestGroup
  void run() {
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

    test(
      'can notify when a new chat is sent using `onNewChat`',
      () async {
        const chat = Chat('message');
        chatRepository.onNewChat(expectAsync1((newChat) {
          expect(chat, equals(chat));
        }, count: 1, reason: 'onNewChat should be called once'));
        chatRepository.send(chat);
      },
      timeout: const Timeout(Duration(seconds: 1)),
    );

    test(
      'can cancel the notification of onNewChat',
      () async {
        const chat = Chat('message');
        final subscription = chatRepository.onNewChat(
          expectAsync1(
            (newChat) {
              expect(chat, equals(chat));
            },
            count: 0,
            reason: 'onNewChat should not be called after cancelation',
          ),
        );
        subscription.cancel();
        chatRepository.send(chat);
      },
      timeout: const Timeout(Duration(seconds: 1)),
    );
  }
}
