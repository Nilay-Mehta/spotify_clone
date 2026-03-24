import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/db_service.dart';
import 'player_screen.dart';

class PlaylistScreen extends StatefulWidget {
  final String playlistName;

  const PlaylistScreen({super.key, required this.playlistName});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  Set<String> _favoriteKeys = {};

  List<Song> get _songs {
    final indices = playlistSongs[widget.playlistName] ?? [];
    return indices.map((i) => allSongs[i]).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favs = await DBService.getFavorites();
    if (mounted) {
      setState(() {
        _favoriteKeys = favs.map((f) => "${f['title']}_${f['artist']}").toSet();
      });
    }
  }

  Future<void> _toggleFavorite(Song song) async {
    final key = "${song.title}_${song.artist}";
    if (_favoriteKeys.contains(key)) {
      await DBService.removeFavorite(song.title, song.artist);
    } else {
      await DBService.insertFavorite(song.title, song.artist, song.url);
    }
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final songs = _songs;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 215, 96),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.playlistName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Playlist header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 30, 215, 96).withOpacity(0.3),
                  Colors.black,
                ],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.queue_music, color: Color.fromARGB(255, 30, 215, 96), size: 60),
                ),
                const SizedBox(height: 12),
                Text(
                  "${songs.length} songs",
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 12),
                // Play all button
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(songs: songs, initialIndex: 0),
                      ),
                    ).then((_) => _loadFavorites());
                  },
                  icon: const Icon(Icons.play_arrow, color: Colors.black),
                  label: const Text("Play All", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 30, 215, 96),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          // Song list
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                final key = "${song.title}_${song.artist}";
                final isFav = _favoriteKeys.contains(key);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[850],
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    song.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? const Color.fromARGB(255, 30, 215, 96) : Colors.grey,
                    ),
                    onPressed: () => _toggleFavorite(song),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(songs: songs, initialIndex: index),
                      ),
                    ).then((_) => _loadFavorites());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
