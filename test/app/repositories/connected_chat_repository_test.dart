import 'package:flutter_test/flutter_test.dart';
import 'package:simple_chat/app/models/chat.dart';
import 'package:simple_chat/app/repositories/connected_chat_repository.dart';
import 'package:simple_chat/app/services/chat_service.dart';

import 'chat_repository_tester.dart';

void main() {
  final tester = ChatRepositoryTester(
    () => ConnectedChatRepository(ChatService()),
    'ConnectedChatRepository',
  );
  group(
    'ConnectedChatRepository without server',
    () {
      tester.run();
    },
  );

  group(
    'ConnectedChatRepository with server',
    () {
      late ConnectedChatRepository repository;

      setUp(() async {
        repository = ConnectedChatRepository(ChatService());
      });
      tearDown(() async {
        await repository.dispose();
      });

      test(
        'can receive a message from other',
        () async {
          const chat = Chat('hello world');
          final stream = repository.chatsStream;
          final result = expectLater(stream, emits([chat]));
          final otherRepository = ConnectedChatRepository(ChatService());
          otherRepository.send(chat);
          await result;
          await otherRepository.dispose();
        },
        timeout: const Timeout(Duration(seconds: 3)),
      );
    },
    skip: 'Should run "flutter pub run grpc_chat:server" first',
  );
}
