import 'package:flutter/material.dart';
import 'package:safetynet/lib.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddContactScreen extends StatefulWidget {
  const AddContactScreen({super.key});

  @override
  State<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    PermissionStatus permissionStatus = await _getPermission();
    if (permissionStatus == PermissionStatus.granted) {
      List<Contact> contacts = (await ContactsService.getContacts()).toList();
      setState(() {
        _contacts = contacts;
      });
    } else {
      if (mounted) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                    title: Text('Permissions error'),
                    content: Text(
                        "Please allow contacts access permission in system settings"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("OK"),
                        onPressed: () => Navigator.of(context).pop(),
                      )
                    ]));
      }
    }
  }

  Future<PermissionStatus> _getPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<void> _sendContactToCloud(name, number) async {
    print('Calling sendMessageToCloud');
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String userID = currentUser.uid;
      addFirebaseContact(userID, name, number);
    }

    // else {
    //   showLoginAlert(context);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(right: 100.0),
              child: Text('SafetyNet'),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Image.asset(
                'assets/icons8-business-network-64.png',
                width: 36,
                height: 28,
                fit: BoxFit.contain,
              ),
            ),
          )
        ]),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = _contacts[index];
          return ListTile(
            onTap: () async {
              String name = contact.displayName ?? 'Unknown';
              String number = contact.phones?.isNotEmpty == true
                  ? contact.phones?.first.value ?? ''
                  : '';
              await DatabaseHelper.instance.addContact(name, number);
              await _sendContactToCloud(name, number);
              Navigator.pop(context, contact);
            },
            title: Text(contact.displayName ?? ''),
            subtitle: Text(contact.phones?.isNotEmpty == true
                ? contact.phones?.first.value ?? ''
                : ''),
          );
        },
      ),
    );
  }
}
// class AddContactPage extends StatefulWidget{

// }