class ChatMessage{
  final String? text;
  final ChatMessageType? type;

  ChatMessage(this.text, this.type);
}

enum ChatMessageType{user, bot}