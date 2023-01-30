import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_chat/app/models/chat.dart';
import 'package:simple_chat/app/pages/chat_page.dart';
import 'package:simple_chat/app/repositories/chat_repository.dart';

void main() {
  group('ChatPage', () {
    late Widget chatPage;
    late ChatRepository chatRepository;
    setUp(
      () {
        chatRepository = ChatRepository();
        return chatPage = MaterialApp(
          home: ChatPage(chatRepository),
        );
      },
    );

    testWidgets('should scaffold widgets because it\'s a page',
        (widgetTester) async {
      await widgetTester.pumpWidget(chatPage);
      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsAtLeastNWidgets(1));
    });

    testWidgets('should have at least one ListView for chat',
        (widgetTester) async {
      await widgetTester.pumpWidget(chatPage);
      final listView = find.byType(ListView);
      expect(listView, findsAtLeastNWidgets(1));
    });

    testWidgets(
      'should have at least one TextInput to send a new chat',
      (widgetTester) async {
        await widgetTester.pumpWidget(chatPage);
        final textInput = find.byType(TextField);
        expect(textInput, findsAtLeastNWidgets(1));
      },
    );
    testWidgets(
      'should have at least one Button to send a new chat',
      (widgetTester) async {
        await widgetTester.pumpWidget(chatPage);
        final button = find.bySubtype<ButtonStyleButton>();
        expect(button, findsAtLeastNWidgets(1));
      },
    );
    testWidgets('can send a message', (widgetTester) async {
      await widgetTester.pumpWidget(chatPage);
      final textInput = find.byType(TextField);
      final button = find.bySubtype<ButtonStyleButton>();
      await widgetTester.enterText(textInput, 'hello world');
      await widgetTester.tap(button);
      expect(
        chatRepository.chats
            .where((element) => element.message == 'hello world'),
        hasLength(1),
      );
    });

    testWidgets('should clear text field when user sends a message',
        (widgetTester) async {
      await widgetTester.pumpWidget(chatPage);
      final textInput = find.byType(TextField);
      final button = find.bySubtype<ButtonStyleButton>();
      await widgetTester.enterText(textInput, 'hello world');
      await widgetTester.tap(button);
      expect(find.text('hello world'), findsNothing);
    });

    testWidgets('can send multiple messages', (widgetTester) async {
      await widgetTester.pumpWidget(chatPage);
      final textInput = find.byType(TextField);
      final button = find.bySubtype<ButtonStyleButton>();
      await widgetTester.enterText(textInput, 'hello world');
      await widgetTester.tap(button);
      await widgetTester.enterText(textInput, 'hello world2');
      await widgetTester.tap(button);
      expect(chatRepository.chats, hasLength(2));
      expect(
        chatRepository.chats,
        containsAllInOrder(
          [
            const Chat('hello world'),
            const Chat('hello world2'),
          ],
        ),
      );
    });

    testWidgets('should show sent messages', (widgetTester) async {
      await widgetTester.pumpWidget(chatPage);
      final textInput = find.byType(TextField);
      final button = find.bySubtype<ButtonStyleButton>();
      await widgetTester.enterText(textInput, 'hello world');
      await widgetTester.tap(button);
      await widgetTester.enterText(textInput, 'hello world2');
      await widgetTester.tap(button);
      await widgetTester.pumpAndSettle();
      expect(find.text('hello world'), findsOneWidget);
      expect(find.text('hello world2'), findsOneWidget);
    });

    testWidgets('should always show the latest message', (widgetTester) async {
      await widgetTester.pumpWidget(chatPage);
      final textInput = find.byType(TextField);
      final button = find.bySubtype<ButtonStyleButton>();
      for (int i = 0; i < 200; ++i) {
        final text = 'hello world $i';
        await widgetTester.enterText(textInput, text);
        await widgetTester.tap(button);
        await widgetTester.pumpAndSettle();
        final target = find.text(text).hitTestable();
        expect(target, findsOneWidget);
      }
    });
  });
}
