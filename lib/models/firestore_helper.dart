import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

Future<List<Map<String, dynamic>>> getFirebaseContacts() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    throw Exception("No authenticated User found");
  }

  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .collection('contacts')
      .get();

  return snapshot.docs
      .map(
          (doc) => {'name': doc.data()['name'], 'number': doc.data()['number']})
      .toList();
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

Future<List<Map<String, dynamic>>> getFirebaseMessages() async {
  User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    throw Exception("No authenticated User found");
  }

  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .collection('messages')
      .get();

  return snapshot.docs
      .map((doc) => {'content': doc.data()['content'], 'contactID': null})
      .toList();
}

Future<bool> contactExistsSQL(String name, String number) async {
  final db = await DatabaseHelper.instance.database;
  final result = await db.query(
    'contacts',
    where: 'name = ? AND number = ?',
    whereArgs: [name, number],
  );
  return result.isNotEmpty;
}

Future<bool> messageExistsSQL(String content) async {
  final db = await DatabaseHelper.instance.database;
  final result = await db.query(
    'savedMessageList',
    where: 'content = ?',
    whereArgs: [content],
  );
  return result.isNotEmpty;
}

Future<void> syncContactsFirebaseSQLite() async {
  List<Map<String, dynamic>> contacts = await getFirebaseContacts();

  for (var contact in contacts) {
    bool exists = await contactExistsSQL(contact['name'], contact['number']);
    if (!exists) {
      await DatabaseHelper.instance
          .addContact(contact['name'], contact['number']);
    }
  }
}

Future<void> syncMessagesFirebaseSQLite() async {
  List<Map<String, dynamic>> messages = await getFirebaseMessages();

  for (var message in messages) {
    bool exists = await messageExistsSQL(message['content']);
    if (!exists) {
      await DatabaseHelper.instance
          .addSavedMessageList(message['content'], null);
    }
  }
}






// Future<List<Message>> getFirebaseMessages(String userID) async {
//   List<Message> messages = [];

//   var snapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userID)
//       .collection('messages')
//       .get();

//   for (var doc in snapshot.docs) {
//     messages.add(Message.fromFirestore(doc));
//   }
//   return messages;
// }



// Future<List<ContactClass>> getFirebaseContacts(String userID) async {
//   List<ContactClass> contacts = [];

//   var snapshot = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userID)
//       .collection('contacts')
//       .get();

//   for (var doc in snapshot.docs) {
//     contacts.add(ContactClass.fromFirestore(doc));
//   }
//   return contacts;
// }




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

// Future<void> saveFirebaseMessageToContact(
//     String userID, String contactID, String messageContent) async {
//   Map<String, dynamic> messageData = {'content': messageContent};
//   await FirebaseFirestore.instance
//       .collection('users')
//       .doc(userID)
//       .collection('contacts')
//       .doc(contactID)
//       .collection('savedMessages')
//       .add(messageData);
// }