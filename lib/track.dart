import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';

import 'no_internet.dart';
import 'trackBLoC.dart';
import 'data_models.dart';

class Track extends StatefulWidget {
  final int trackId;
  final String trackName;
  const Track({super.key, required this.trackId, required this.trackName});

  @override
  State<Track> createState() => _TrackState();
}

class _TrackState extends State<Track> {
  bool hasInternet = true;
  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final TrackBLoC trackBLoC = TrackBLoC(trackId: widget.trackId);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.trackName),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                child: StreamBuilder<List<Tracks>>(
                    stream: trackBLoC.track,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Tracks>> snapshot) {
                      if (hasInternet) {
                        if (snapshot.hasData) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            30, 0, 20, 8),
                                        child: Image.asset(
                                          'assets/thumbnail.jpg',
                                          height: 100,
                                          width: 100,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 15, 0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              final url = Uri.parse(
                                                  snapshot.data![0].shareUrl);
                                              if (await canLaunchUrl(url)) {
                                                await launchUrl(url);
                                              } else {
                                                throw 'Could not launch $url';
                                              }
                                            },
                                            child: const Icon(
                                              CupertinoIcons.link,
                                              color: Colors.blue,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                                Expanded(
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 10),
                                            child: Text(
                                                snapshot.data![0].trackName,
                                                style: const TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 255, 84, 86),
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        Text(snapshot.data![0].artistName,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: Text(snapshot.data![0].genere,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ]),
                                ),
                              ]);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const Padding(
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                            child: Center(child: CircularProgressIndicator()));
                      } else {
                        return Container();
                      }
                    }),
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                  child: Text('Lyrics',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 84, 86),
                      )),
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Lyrics>>(
                    stream: trackBLoC.trackLyrics,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Lyrics>> snapshot) {
                      if (hasInternet) {
                        if (snapshot.hasData) {
                          return Card(
                            color: const Color.fromARGB(255, 255, 84, 86),
                            elevation: 5.0,
                            child: ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(snapshot.data![index].lyrics,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0)),
                                  ),
                                );
                              },
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                              Text('Loading Lyrics'),
                              SizedBox(height: 30),
                              CircularProgressIndicator(),
                            ]));
                      } else {
                        return const Center(
                          child: NoInternet(),
                        );
                      }
                    }),
              ),
            ],
          ),
        )));
  }
}
