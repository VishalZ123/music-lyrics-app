import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

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

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  const Text(
                    'Music App\n\n'
                    'This app is made using Musixmatch APIs.\n\n'
                    'The app just dislays the trending tracks of the day,\n\n'
                    'Details about the tracks, and also the lyrics of the songs.\n\n'
                    'It also displays a "No Internet" page when the internet connection is lost.\n\n'
                    'The app is open source and can be found on GitHub at:\n\n',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(255, 255, 84, 86),
                    ),
                  ),
                  GestureDetector(
                      onTap: () async {
                        final url = Uri.parse(
                            'https://github.com/VishalZ123/music-app');
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: const Text(
                        'https://github.com/VishalZ123/music-app',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                        ),
                      ))
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
