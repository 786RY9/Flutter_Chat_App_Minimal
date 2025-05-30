import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String recieverId;
  final Timestamp timestamp;
  final String message;

  Message({
    required this.recieverId,
    required this.senderEmail,
    required this.senderId,
    required this.timestamp,
    required this.message
  });

  // convert to map
  Map<String, dynamic> toMap() {
    return {
      'senderEmail': senderEmail,
      'senderId': senderId,
      'recieverId': recieverId,
      'timestamp': timestamp,
      'message': message
    };
  }
}
