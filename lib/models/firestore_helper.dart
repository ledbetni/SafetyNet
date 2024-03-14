import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safetynet/lib.dart';

Future<void> addFirebaseContact(
    String userID, String name, String number) async {
  Map<String, dynamic> contactData = {
    'name': name,
    'number': number,
  };

  await FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('contacts')
      .add(contactData);
}

Future<List<ContactClass>> getFirebaseContacts(String userID) async {
  List<ContactClass> contacts = [];

  var snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('contacts')
      .get();

  for (var doc in snapshot.docs) {
    contacts.add(ContactClass.fromFirestore(doc));
  }
  return contacts;
}

Future<void> addFirebaseMessage(String userID, String messageContent) async {
  print('Attempting to send message to firebase');
  Map<String, dynamic> messageData = {
    'content': messageContent,
    'timestamp': null
  };

  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('messages')
        .add(messageData);
    print("Success");
  } catch (e) {
    print('Failed to send message: $e');
  }
}

Future<List<Message>> getFirebaseMessages(String userID) async {
  List<Message> messages = [];

  var snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('messages')
      .get();

  for (var doc in snapshot.docs) {
    messages.add(Message.fromFirestore(doc));
  }
  return messages;
}

Future<void> saveFirebaseMessageToContact(
    String userID, String contactID, String messageContent) async {
  Map<String, dynamic> messageData = {'content': messageContent};
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userID)
      .collection('contacts')
      .doc(contactID)
      .collection('savedMessages')
      .add(messageData);
}

// Future<List<Message>> getContactMessages(Str)

















// Future<void> addFirebaseSavedMessageList(
//     String userID, Map<String, dynamic> savedMessageListData) async {
//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userID)
//       .collection('savedMessageList')
//       .add(savedMessageListData);
// }

// Future<List<QueryDocumentSnapshot>> getFirebaseMessages(String userID) async {
//   var snapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userID)
//       .collection('messages')
//       .get();
//   return snapshot.docs;
// }