// ignore_for_file: non_constant_identifier_names

// data model for Trending Tracks to be displayed on the home screen
class TrendingTracks {
  final int trackId;
  final String trackName;
  final String artistName;

  TrendingTracks({
    required this.trackId,
    required this.trackName,
    required this.artistName,
  });

  factory TrendingTracks.fromJson(Map<String, dynamic> json) {
    return TrendingTracks(
      trackId: json['track_id'],
      trackName: json['track_name'],
      artistName: json['artist_name'],
    );
  }
}

// data model for Track to be displayed on the track screen
class Tracks {
  final int trackId;
  final String trackName;
  final String artistName;
  final String genere;
  final String shareUrl;

  Tracks({
    required this.trackId,
    required this.trackName,
    required this.artistName,
    required this.genere,
    required this.shareUrl,
  });

  factory Tracks.fromJson(Map<String, dynamic> json) {
    return Tracks(
      trackId: json['track_id'],
      trackName: json['track_name'],
      artistName: json['artist_name'],
      genere: json['primary_genres']['music_genre_list'][0]['music_genre']
          ['music_genre_name'],
      shareUrl: json['track_share_url'],
    );
  }
}

// data model for Lyrics to be displayed on the track screen
class Lyrics {
  final String lyrics;

  Lyrics({
    required this.lyrics,
  });

  factory Lyrics.fromJson(Map<String, dynamic> json) {
    return Lyrics(
      lyrics: json['lyrics_body'],
    );
  }
}
