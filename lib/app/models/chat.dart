import 'package:equatable/equatable.dart';

class Chat with EquatableMixin {
  const Chat(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
