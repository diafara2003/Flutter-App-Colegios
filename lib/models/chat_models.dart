import 'package:autraliano/models/person.dart';

class ChatDTO {
  final Usuario sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool isLiked;
  final bool unread;
  final int id;
  final String asunto;
  final String sendTo;

  ChatDTO(
      {required this.sender,
      required this.time,
      required this.text,
      required this.isLiked,
      required this.unread,
      required this.id,
      required this.asunto,
      required this.sendTo});
}
