import 'package:flutter/material.dart';
import 'package:safetynet/lib.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SafetynetScreen extends StatefulWidget {
  const SafetynetScreen({super.key});

  @override
  State<SafetynetScreen> createState() => _SafetynetScreenState();
}

class _SafetynetScreenState extends State<SafetynetScreen> {
  List<Map<String, dynamic>> _contacts = [];
  List<Map<String, dynamic>> _savedMessages = [];
  Map<int, bool> _includeLocationForMessage = {};
  //Map<String, Set<String>> selectedMessages = {};

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _fetchSavedMessages();
    // for (var contact in _contacts) {
    //   selectedMessages[contact['name']!] = {};
    // }
  }

  void _fetchContacts() async {
    List<Map<String, dynamic>> fetchedContacts =
        await DatabaseHelper.instance.getContacts();
    setState(() {
      _contacts = fetchedContacts;
      // for (var contact in _contacts) {
      //   selectedMessages[contact['name']!] = {};
      // }
    });
  }

  void _fetchSavedMessages() async {
    List<Map<String, dynamic>> fetchedSavedMessages =
        await DatabaseHelper.instance.getSavedMessageList();
    setState(() {
      _savedMessages = fetchedSavedMessages;
    });
  }

  // void _sendAllMessages() async {
  //   for (var contactName in selectedMessages.keys) {
  //     Map<String, dynamic>? contact = _contacts.firstWhere(
  //         (c) => c['name'] == contactName,
  //         orElse: () =>
  //             <String, dynamic>{'name': 'Unknown', 'number': 'No Number'});
  //     if (contact['name'] != 'Unknown') {
  //       String phoneNumber = contact['number'];
  //       Set<String> messages = selectedMessages[contactName]!;

  //       for (var message in messages) {
  //         String result =
  //             await sendSMS(message: message, recipients: [phoneNumber])
  //                 .catchError((onError) {
  //           print(onError.toString());
  //           return 'Failed to send message!';
  //         });
  //         print(result);
  //       }
  //     }
  //   }
  // }

  void _sendMessageToContact(
      String contactName, String message, bool includeLocation) async {
    Map<String, dynamic>? contact = _contacts.firstWhere(
        (c) => c['name'] == contactName,
        orElse: () =>
            <String, dynamic>{'name': 'Unknown', 'number': 'No Number'});

    if (contact['name'] != 'Unknown') {
      String phoneNumber = contact['number'];
      String finalMessage = message;
      //  TO DO IMPLEMENT GEOLOCATION
      if (includeLocation) {
        // finalMessage += "\nLocation Pin Goes Here";
        Position location = await determinePosition();
        String messageWithPin =
            await appendLocationToMessage(finalMessage, location);
        String result =
            await sendSMS(message: messageWithPin, recipients: [phoneNumber])
                .catchError((onError) {
          print(onError.toString());
          return 'Failed to send message';
        });
        print(result);
      }

      String result =
          await sendSMS(message: finalMessage, recipients: [phoneNumber])
              .catchError((onError) {
        print(onError.toString());
        return 'Failed to send message';
      });
      print(result);
    }
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we are unable to request permission.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> appendLocationToMessage(
      String message, Position position) async {
    try {
      String mapPinUrl =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";
      String messageWithMapPin = '$message\nMy Location: $mapPinUrl';
      return messageWithMapPin;
    } catch (e) {
      print('Failed to append map pin: $e');
      return message;
    }
  }

  Future<void> _checkLoginStatusSync() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String userID = currentUser.uid;
      await syncContactsFirebaseSQLite();
      await syncMessagesFirebaseSQLite();
      _fetchContacts();
      _fetchSavedMessages();
      //addFirebaseMessage(userID, messageContent);
    } else {
      showLoginAlert(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          String contactName = _contacts[index]['name'];
          String contactNumber = _contacts[index]['number'];
          return ExpansionTile(
            title: Text(contactName),
            subtitle: Text(contactNumber),
            children:
                _savedMessages.map<Widget>(((Map<String, dynamic> messageMap) {
              String messageContent = messageMap['content'];
              bool includeLocation = false;
              return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateLocal) {
                return ListTile(
                    title: Text(messageContent),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon(Icons.location_pin),
                        // Checkbox(
                        //   value: includeLocation,
                        //   onChanged: (bool? value) {
                        //     setStateLocal(() => includeLocation = value!);
                        //   },
                        // ),
                        IconButton(
                          icon: Icon(
                            Icons.location_pin,
                            color: includeLocation ? Colors.green : Colors.grey,
                          ),
                          onPressed: () {
                            setStateLocal(
                              () => includeLocation = !includeLocation,
                            );
                            print("includeLocation: $includeLocation");
                          },
                        ),
                        IconButton(
                            onPressed: () {
                              _sendMessageToContact(
                                  contactName, messageContent, includeLocation);
                            },
                            icon: Icon(Icons.send))
                      ],
                    ));
              });
            })).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _checkLoginStatusSync();
        },
        tooltip: 'Add Message',
        child: Icon(Icons.cloud_outlined),
      ),
    );
  }
}
