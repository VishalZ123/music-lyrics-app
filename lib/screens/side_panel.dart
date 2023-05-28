import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_app/screens/about.dart';

class SidePanel extends StatelessWidget {
  const SidePanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(
              CupertinoIcons.info_circle_fill,
              color: Colors.blue,
              size: 30,
            ),
            title: const Text('About',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 84, 86),
                )),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ));
            },
          ),
          ListTile(
            trailing: Image.asset(
              'assets/logo.jpg',
              width: 170,
            ),
            subtitle: const Text(
              'Powered by',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
