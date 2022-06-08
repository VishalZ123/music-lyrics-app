import 'dart:async';
import 'dart:convert';
import 'data_models.dart';
import 'package:http/http.dart' as http;

const String API_KEY = 'YOUR_API_KEY_HERE';
const String BASE_URL = 'https://api.musixmatch.com/ws/1.1/';
String chartTracksUrl = '${BASE_URL}chart.tracks.get?apikey=$API_KEY';

class TrendingTrackBLoC {
  final _trendingTracksController = StreamController<List<TrendingTracks>>();

  Stream<List<TrendingTracks>> get trendingTracks =>
      _trendingTracksController.stream;

  // constructor
  TrendingTrackBLoC() {
    getTrendingTracks();
  }

  // function to get trending tracks
  void getTrendingTracks() async {
    final response = await http.get(Uri.parse(chartTracksUrl));
    List<TrendingTracks> trendingTracks = [];

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      for (var track in jsonResponse['message']['body']['track_list']) {
        trendingTracks.add(TrendingTracks.fromJson(track['track']));
      }

      _trendingTracksController.sink.add(trendingTracks);
    } else {
      throw Exception('Failed to load Tracks');
    }
  }

  void dispose() {
    _trendingTracksController.close();
  }
}

class TrackBLoC {
  final _trackController = StreamController<List<Tracks>>(); // track details
  final _trackLyricsController =
      StreamController<List<Lyrics>>(); // track lyrics

  Stream<List<Tracks>> get track =>
      _trackController.stream; // getter for track details
  Stream<List<Lyrics>> get trackLyrics =>
      _trackLyricsController.stream; // getter for track lyrics

  int trackId;
  TrackBLoC({required this.trackId}) {
    String trackUrl = '${BASE_URL}track.get?track_id=$trackId&apikey=$API_KEY';
    getTrack(trackUrl);

    String trackLyricsUrl =
        '${BASE_URL}track.lyrics.get?track_id=$trackId&apikey=$API_KEY';
    getTrackLyrics(trackLyricsUrl);
  }

  // function to get track details
  void getTrack(String trackUrl) async {
    final response = await http.get(Uri.parse(trackUrl));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      _trackController.sink
          .add([Tracks.fromJson(jsonResponse['message']['body']['track'])]);
    } else {
      throw Exception('Failed to load Track Details');
    }
  }

  // function to get track lyrics
  void getTrackLyrics(String trackLyricsUrl) async {
    final response = await http.get(Uri.parse(trackLyricsUrl));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      _trackLyricsController.sink.add([
        Lyrics.fromJson(jsonResponse['message']['body']['lyrics']),
      ]);
    } else {
      throw Exception('Failed to load Track Lyrics');
    }
  }

  // function to dispose the stream controllers
  void dispose() {
    _trackController.close();
    _trackLyricsController.close();
  }
}
