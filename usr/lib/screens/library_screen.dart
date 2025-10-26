import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/song_tile.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Library'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Show user profile/login
            },
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Favorites'),
                Tab(text: 'Playlists'),
                Tab(text: 'Downloaded'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildFavoritesTab(appState),
                  _buildPlaylistsTab(),
                  _buildDownloadedTab(appState),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildFavoritesTab(AppState appState) {
    final favorites = appState.allSongs.where((song) => song.isFavorite).toList();
    return favorites.isEmpty
        ? const Center(child: Text('No favorite songs yet'))
        : ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) => SongTile(song: favorites[index]),
          );
  }

  Widget _buildPlaylistsTab() {
    // TODO: Implement playlists
    return const Center(child: Text('Playlists coming soon'));
  }

  Widget _buildDownloadedTab(AppState appState) {
    final downloaded = appState.allSongs.where((song) => song.isDownloaded).toList();
    return downloaded.isEmpty
        ? const Center(child: Text('No downloaded songs yet'))
        : ListView.builder(
            itemCount: downloaded.length,
            itemBuilder: (context, index) => SongTile(song: downloaded[index]),
          );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/search');
            break;
          case 2:
            // Already on library
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/now-playing');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
        BottomNavigationBarItem(icon: Icon(Icons.play_circle), label: 'Now Playing'),
      ],
    );
  }
}