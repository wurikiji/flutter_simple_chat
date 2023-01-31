import 'package:flutter_test/flutter_test.dart';
import 'package:simple_chat/app/models/chat.dart';
import 'package:simple_chat/app/repositories/chat_repository.dart';

import 'chat_repository_tester.dart';

void main() {
  group('Chat', () {
    test('has a message', () {
      const chat = Chat('message');
      expect(chat.message, equals('message'));
    });
  });
  group('ChatRepository', () {
    final tester =
        ChatRepositoryTester(() => ChatRepository(), 'ChatRepository');

    tester.run();
  });
}
