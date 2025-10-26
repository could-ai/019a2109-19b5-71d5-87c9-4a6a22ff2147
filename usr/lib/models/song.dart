class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String url;
  final String imageUrl;
  final Duration duration;
  final List<String> genres;
  bool isFavorite;
  bool isDownloaded;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.url,
    required this.imageUrl,
    required this.duration,
    required this.genres,
    this.isFavorite = false,
    this.isDownloaded = false,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      album: json['album'],
      url: json['url'],
      imageUrl: json['imageUrl'],
      duration: Duration(seconds: json['duration']),
      genres: List<String>.from(json['genres']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'url': url,
      'imageUrl': imageUrl,
      'duration': duration.inSeconds,
      'genres': genres,
    };
  }

  Song copyWith({
    bool? isFavorite,
    bool? isDownloaded,
  }) {
    return Song(
      id: id,
      title: title,
      artist: artist,
      album: album,
      url: url,
      imageUrl: imageUrl,
      duration: duration,
      genres: genres,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
    );
  }
}