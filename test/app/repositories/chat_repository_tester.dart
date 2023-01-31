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
      'can notify when a new chat is sent using `onSend`',
      () async {
        const chat = Chat('message');
        chatRepository.onSend(expectAsync1((newChat) {
          expect(chat, equals(chat));
        }, count: 1, reason: 'onNewChat should be called once'));
        chatRepository.send(chat);
      },
      timeout: const Timeout(Duration(seconds: 1)),
    );

    test(
      'can cancel the notification of onSend',
      () async {
        const chat = Chat('message');
        final subscription = chatRepository.onSend(
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

    test('can receive a new chat', () async {
      const chat = Chat('message');
      final chatStream = chatRepository.chatsStream;
      final result = expectLater(chatStream, emits(contains(chat)));
      chatRepository.receive(chat);
      await result;
    });

    test('should notify onReceive when receive is called', () async {
      const chat = Chat('message');
      bool called = false;
      final subscription = chatRepository.onReceive(
        (_) {
          called = true;
        },
      );
      chatRepository.receive(chat);
      await Future.delayed(const Duration(milliseconds: 1));
      subscription.cancel();
      expect(called, isTrue);
    });

    test('should not notify onReceive when send is called', () async {
      const chat = Chat('message');
      bool called = false;
      final subscription = chatRepository.onReceive(
        (_) {
          called = true;
        },
      );
      chatRepository.send(chat);
      await Future.delayed(const Duration(milliseconds: 1));
      subscription.cancel();
      expect(called, isFalse);
    });
    test('should call OnSend observers when send is called', () async {
      bool called = false;
      final onSend = CallbackOnSendOnReceive(
        onSend: (_) {
          called = true;
        },
        onReceive: (_) {},
      );
      final chatRepository = ChatRepository(
        onSendObservers: <OnSend>[
          onSend,
        ],
      );
      const chat = Chat('message');
      chatRepository.send(chat);
      await Future.delayed(const Duration(milliseconds: 1));
      expect(called, isTrue);
    });

    test('should call OnReceive observers when receive is called', () async {
      bool called = false;
      final onReceive = CallbackOnSendOnReceive(
        onSend: (_) {},
        onReceive: (_) {
          called = true;
        },
      );
      final chatRepository = ChatRepository(
        onReceiveObservers: [
          onReceive,
        ],
      );
      const chat = Chat('message');
      chatRepository.receive(chat);
      await Future.delayed(const Duration(milliseconds: 1));
      expect(called, isTrue);
    });
  }
}

class CallbackOnSendOnReceive with OnSend, OnReceive {
  CallbackOnSendOnReceive({
    required this.onSend,
    required this.onReceive,
  });

  @override
  final void Function(Chat newChat) onReceive;

  @override
  final void Function(Chat newChat) onSend;
}
