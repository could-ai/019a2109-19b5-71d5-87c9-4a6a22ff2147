import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'song.dart';

class AppState extends ChangeNotifier {
  List<Song> _allSongs = [];
  Song? _currentSong;
  List<Song> _trendingSongs = [];
  List<Song> _recommendedSongs = [];
  List<Song> _recentlyPlayed = [];

  AppState() {
    _loadSampleData();
    _loadUserPreferences();
  }

  List<Song> get allSongs => _allSongs;
  Song? get currentSong => _currentSong;
  List<Song> get trendingSongs => _trendingSongs;
  List<Song> get recommendedSongs => _recommendedSongs;
  List<Song> get recentlyPlayed => _recentlyPlayed;

  void _loadSampleData() {
    // Sample data - in real app, fetch from API
    _allSongs = [
      Song(
        id: '1',
        title: 'Blinding Lights',
        artist: 'The Weeknd',
        album: 'After Hours',
        url: 'https://example.com/audio1.mp3',
        imageUrl: 'https://via.placeholder.com/300x300?text=Blinding+Lights',
        duration: const Duration(minutes: 3, seconds: 20),
        genres: ['Pop', 'R&B'],
      ),
      Song(
        id: '2',
        title: 'Watermelon Sugar',
        artist: 'Harry Styles',
        album: 'Fine Line',
        url: 'https://example.com/audio2.mp3',
        imageUrl: 'https://via.placeholder.com/300x300?text=Watermelon+Sugar',
        duration: const Duration(minutes: 2, seconds: 54),
        genres: ['Pop', 'Rock'],
      ),
      // Add more sample songs...
    ];
    _trendingSongs = _allSongs.take(5).toList();
    _recommendedSongs = _allSongs.skip(5).take(5).toList();
    _recentlyPlayed = _allSongs.take(3).toList();
  }

  void _loadUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    // Load favorites, downloads, etc.
    notifyListeners();
  }

  void setCurrentSong(Song song) {
    _currentSong = song;
    _addToRecentlyPlayed(song);
    notifyListeners();
  }

  void _addToRecentlyPlayed(Song song) {
    _recentlyPlayed.removeWhere((s) => s.id == song.id);
    _recentlyPlayed.insert(0, song);
    if (_recentlyPlayed.length > 10) {
      _recentlyPlayed = _recentlyPlayed.take(10).toList();
    }
  }

  void toggleFavorite(Song song) {
    final index = _allSongs.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      _allSongs[index] = song.copyWith(isFavorite: !song.isFavorite);
      notifyListeners();
    }
  }

  void toggleDownload(Song song) {
    final index = _allSongs.indexWhere((s) => s.id == song.id);
    if (index != -1) {
      _allSongs[index] = song.copyWith(isDownloaded: !song.isDownloaded);
      notifyListeners();
    }
  }

  List<Song> getRecommendations(String userId) {
    // Simple AI logic: recommend based on favorite genres
    final favoriteGenres = _allSongs
        .where((song) => song.isFavorite)
        .expand((song) => song.genres)
        .toSet();

    return _allSongs
        .where((song) => !song.isFavorite &&
                        song.genres.any((genre) => favoriteGenres.contains(genre)))
        .take(10)
        .toList();
  }
}