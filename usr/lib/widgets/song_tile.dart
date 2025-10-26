import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import '../models/song.dart';

class SongTile extends StatelessWidget {
  final Song song;

  const SongTile({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(song.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(song.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(song.artist, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: IconButton(
        icon: Icon(song.isFavorite ? Icons.favorite : Icons.favorite_border),
        onPressed: () {
          // TODO: Toggle favorite
        },
      ),
      onTap: () async {
        // Play the song
        final mediaItem = MediaItem(
          id: song.id,
          album: song.album,
          title: song.title,
          artist: song.artist,
          duration: song.duration,
          artUri: Uri.parse(song.imageUrl),
        );
        await AudioService.playMediaItem(mediaItem);
      },
    );
  }
}