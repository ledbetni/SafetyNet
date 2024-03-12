import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _someSwitchValue = false;

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
      body: ListView(
        children: <Widget>[
          SwitchListTile(
            title: const Text('Some Setting'),
            value: _someSwitchValue,
            onChanged: (bool value) {
              setState(() {
                _someSwitchValue = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('Icon attribution from icons8.com business network icon'),
          )
          // Add more settings widgets here
        ],
      ),
    );
  }
}



// appBar: AppBar(
//         title:
//             Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//           //SizedBox(width: 60),
//           Padding(
//             padding: const EdgeInsets.only(right: 45.0),
//             child: Text('SafetyNet'),
//           ),
//           SizedBox(width: 6),
//           Image.asset('assets/icons8-business-network-64.png',
//               width: 36, height: 36)
//         ]),
//         centerTitle: false,

// AppBar(
//         title: Text(''),
//         centerTitle: true,
//         flexibleSpace: LayoutBuilder(builder: ((context, constraints) {
//           final bool isBackButtonPresent = Navigator.canPop(context);
//           final double titleLeftAlignment = isBackButtonPresent ? 60.0 : 20.0;
//           return Stack(
//             children: <Widget>[
//               Positioned(
//                   left: titleLeftAlignment,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Text(
//                       'SafetyNet',
//                     ),
//                   )),
//               Positioned(
//                   child: Image.asset(
//                 'assets/icons8-business-network-64.png',
//                 width: 36,
//                 height: 36,
//               ))
//             ],
//           );
//         })),
//       ),