import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String? id;
  String? content;
  DateTime? timestamp;

  Message({this.id, this.content, this.timestamp});

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Message(
        id: doc.id,
        content: data['content'] ?? '',
        timestamp: (data['timestamp'] as Timestamp).toDate());
  }
}
