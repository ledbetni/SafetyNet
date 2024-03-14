import 'package:cloud_firestore/cloud_firestore.dart';

class ContactClass {
  String? id;
  String? name;
  String? number;

  ContactClass({this.id, this.name, this.number});

  factory ContactClass.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return ContactClass(
        id: doc.id, name: data['name'] ?? '', number: data['number'] ?? '');
  }
}
