import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../widgets/song_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final appState = Provider.of<AppState>(context, listen: false);
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() => _searchResults = []);
    } else {
      setState(() => _searchResults = appState.allSongs
          .where((song) => song.title.toLowerCase().contains(query) ||
                            song.artist.toLowerCase().contains(query))
          .toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search songs, artists, albums...',
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _searchResults.isEmpty
          ? const Center(child: Text('Start typing to search...'))
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) => SongTile(song: _searchResults[index]),
            ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            // Already on search
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/library');
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