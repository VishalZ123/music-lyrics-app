import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:music_app/data_models.dart';
import 'package:music_app/screens/track.dart';
import 'package:music_app/trackBLoC.dart';

import 'side_panel.dart';
import 'no_internet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  final TrendingTrackBLoC _trendingTrackBLoC = TrendingTrackBLoC();
  @override
  void dispose() {
    subscription.cancel();
    _trendingTrackBLoC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SidePanel(),
      appBar: AppBar(
        title: const Text('Music App'),
      ),
      body: SafeArea(
        child: StreamBuilder<List<TrendingTracks>>(
          stream: _trendingTrackBLoC.trendingTracks,
          builder: (BuildContext context,
              AsyncSnapshot<List<TrendingTracks>> snapshot) {
            if (hasInternet) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Track(
                              trackId: snapshot.data![index].trackId,
                              trackName: snapshot.data![index].trackName,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 2.0,
                        child: ListTile(
                          title: Text(snapshot.data![index].trackName),
                          subtitle: Text(snapshot.data![index].artistName),
                          leading: Image.asset(
                            'assets/thumbnail.jpg',
                            height: 50,
                            width: 50,
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(
                child: NoInternet(),
              );
            }
          },
        ),
      ),
    );
  }
}
