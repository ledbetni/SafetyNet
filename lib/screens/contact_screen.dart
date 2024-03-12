import 'package:flutter/material.dart';
import 'package:safetynet/lib.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key, required this.title});

  final String title;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  //List<Contact> _contacts = [];
  List<Map<String, dynamic>> _contacts = [];

  @override
  void initState() {
    super.initState();

    _fetchContacts();
  }

  void _fetchContacts() async {
    List<Map<String, dynamic>> fetchedContacts =
        await DatabaseHelper.instance.getContacts();
    setState(() {
      _contacts = fetchedContacts;
    });
  }

  void _deleteContact(int id) async {
    int deleteContact = await DatabaseHelper.instance.deleteContact(id);
    _fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          String contactName = _contacts[index]['name'];
          String contactNumber = _contacts[index]['number'];
          return ListTile(
            title: Text(contactName),
            subtitle: Text(contactNumber),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // IconButton(
                //     onPressed: () => ,
                //     icon: Icon(Icons.message)),
                IconButton(
                    onPressed: () => _deleteContact(_contacts[index]['id']),
                    icon: Icon(Icons.delete))
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final selectedContact = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddContactScreen()));
          if (selectedContact != null) {
            _fetchContacts();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: Center(
  //         child: Text('ContactScreen'),
  //       ),
  //       floatingActionButton: Stack(
  //         children: <Widget>[
  //           Positioned(
  //               child: FloatingActionButton(
  //             onPressed: (() {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => const AddContactScreen()));
  //             }),
  //             child: const Icon(Icons.add),
  //           ))
  //         ],
  //       ));
  // }