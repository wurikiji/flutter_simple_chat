import 'package:flutter/material.dart';
import 'package:simple_chat/app/models/chat.dart';
import 'package:simple_chat/app/repositories/chat_repository.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
    this.repository, {
    Key? key,
  }) : super(key: key);

  final ChatRepository repository;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ChatListView(widget: widget),
          ),
          ChatInputBar(
            inputController: _inputController,
            send: sendMessage,
          ),
        ],
      ),
    );
  }

  void sendMessage() {
    widget.repository.send(
      Chat(_inputController.text),
    );
    _inputController.clear();
  }
}

class ChatInputBar extends StatelessWidget {
  const ChatInputBar({
    super.key,
    required TextEditingController inputController,
    required this.send,
  }) : _inputController = inputController;

  final TextEditingController _inputController;
  final void Function() send;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _inputController,
            textInputAction: TextInputAction.send,
            onEditingComplete: send,
          ),
        ),
        FilledButton(
          onPressed: send,
          child: null,
        ),
      ],
    );
  }
}

class ChatListView extends StatelessWidget {
  const ChatListView({
    super.key,
    required this.widget,
  });

  final ChatPage widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: widget.repository.chatsStream,
      builder: (context, snapshot) {
        List<Chat>? chats;
        if (snapshot.hasData) {
          chats = snapshot.data! as List<Chat>;
        }
        return ListView(
          reverse: true,
          children: chatsTiles(chats) ?? [],
        );
      },
    );
  }

  List<ListTile>? chatsTiles(List<Chat>? chats) {
    return chats?.reversed
        .map(
          (e) => ListTile(
            title: Text(e.message),
          ),
        )
        .toList();
  }
}
