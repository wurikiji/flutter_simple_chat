import 'package:flutter_test/flutter_test.dart';
import 'package:simple_chat/app/models/chat.dart';
import 'package:simple_chat/app/services/chat_service.dart';

void main() {
  group(
    'ChatService',
    () {
      late ChatService chatService;
      setUp(() async {
        chatService = ChatService();
      });

      tearDown(() async => await chatService.close());

      test('can send a message', () {
        const chat = Chat('hello world');
        final sent = chatService.send(chat);
        expect(sent, isTrue);
      });

      test(
        'can recevie a message from other',
        () async {
          const chat = Chat('hello world');
          final otherService = ChatService();
          final stream = chatService.newChatStream;
          final result = expectLater(stream, emits('hello world'));
          otherService.send(chat);
          await result;
          await otherService.close();
        },
      );
    },
    skip: 'Should run "flutter pub run grpc_chat:server" first',
  );
}
