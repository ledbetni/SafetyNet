import 'package:flutter/material.dart';
import 'package:safetynet/lib.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SavedMessagesScreen extends StatefulWidget {
  const SavedMessagesScreen({super.key});

  @override
  State<SavedMessagesScreen> createState() => _SavedMessagesScreenState();
}

class _SavedMessagesScreenState extends State<SavedMessagesScreen> {
  //List<Contact> _savedMessages = [];
  List<Map<String, dynamic>> _savedMessages = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _fetchSavedMessages();
    _textController.addListener(() {
      if (_textController.text.isEmpty) {
        _focusNode.unfocus();
      }
      // Future.delayed(Duration(milliseconds: 100), () {
      //   _focusNode.requestFocus();
      // });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _fetchSavedMessages() async {
    List<Map<String, dynamic>> fetchedSavedMessages =
        await DatabaseHelper.instance.getSavedMessageList();
    setState(() {
      _savedMessages = fetchedSavedMessages;
    });
  }

  void _deleteSavedMessage(int id) async {
    int deleteSavedMessage =
        await DatabaseHelper.instance.deleteSavedMessageList(id);
    _fetchSavedMessages();
  }

  void _showTextInputBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: 'Enter your message',
                      hintText:
                          "Getting in an Uber, will text when home safe!"),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await DatabaseHelper.instance
                          .addSavedMessageList(_textController.text, null);
                      _fetchSavedMessages();
                      Navigator.pop(context);
                      setState(() {
                        _textController.clear();
                        _focusNode.unfocus();
                      });
                    },
                    child: Text('Save Message'))
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _savedMessages.length,
        itemBuilder: (context, index) {
          String messageContent = _savedMessages[index]['content'];

          return ListTile(
            title: Text(messageContent),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () =>
                        _deleteSavedMessage(_savedMessages[index]['id']),
                    icon: Icon(Icons.delete))
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTextInputBottomSheet,
        tooltip: 'Add Message',
        child: Icon(Icons.add),
      ),
    );
  }
}
