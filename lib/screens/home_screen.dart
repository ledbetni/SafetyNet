import 'package:flutter/material.dart';
import 'package:safetynet/lib.dart';
import 'package:safetynet/screens/map_screen.dart';

class HomeScreen extends StatefulWidget {
  final String title = "SafetyNet";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _Pages = <Widget>[
    SafetynetScreen(),
    ContactScreen(title: 'Add Contacts'),
    // Text('Profile Page',
    //     style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    SavedMessagesScreen(),
    MapScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Text('SafetyNet'),
          ),
          Positioned(
              left: 220,
              child: Image.asset(
                'assets/icons8-business-network-64.png',
                width: 36,
                height: 28,
                //fit: BoxFit.contain,
              ))
        ]),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
              icon: Icon(Icons.settings)),
        ],
      ),
      body: Center(
        child: _Pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // showSelectedLabels: false,
        // showUnselectedLabels: false,
        items: <BottomNavigationBarItem>[
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.home),
          //   label: 'Home',
          // ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/icons8-business-network-64.png',
                width: 24, height: 24),
            label: 'SafetyNet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.import_contacts),
            label: 'Contacts',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Profile',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Settings',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}


// Settings button needs fixing

      //   actions:<Widget>[
      //     IconButton(icon: Icon(Icons.settings),onPressed: (() {
      //         Navigator.push(context,
      //             MaterialPageRoute(builder: (context) => const SettingsScreen()));
      //       },)
      // )]

      // appBar: AppBar(
      //   title:
      //       Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      //     SizedBox(width: 60),
      //     Text('SafetyNet'),
      //     SizedBox(width: 6),
      //     Image.asset('assets/icons8-business-network-64.png',
      //         width: 36, height: 36)
      //   ]),
      //   centerTitle: true,
      //   actions: <Widget>[
      //     IconButton(
      //         onPressed: () {
      //           Navigator.push(
      //             context,
      //             MaterialPageRoute(builder: (context) => SettingsScreen()),
      //           );
      //         },
      //         icon: Icon(Icons.settings)),
      //   ],
      // ),