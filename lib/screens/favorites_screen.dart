import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/song.dart';
import 'player_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final data = await DBService.getFavorites();
    if (mounted) setState(() => favorites = data);
  }

  Future<void> _removeFavorite(String title, String artist) async {
    await DBService.removeFavorite(title, artist);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 215, 96),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Liked Songs",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: favorites.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, color: Colors.grey[700], size: 80),
                  const SizedBox(height: 16),
                  Text(
                    "No liked songs yet",
                    style: TextStyle(color: Colors.grey[500], fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tap the heart icon on any song to save it here",
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Play all button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Text(
                        "${favorites.length} songs",
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          final songs = favorites
                              .map((f) => Song(
                                    title: f['title'],
                                    artist: f['artist'],
                                    url: f['url'],
                                  ))
                              .toList();
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
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      final fav = favorites[index];
                      return Dismissible(
                        key: Key("${fav['title']}_${fav['artist']}"),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (_) => _removeFavorite(fav['title'], fav['artist']),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey[850],
                            child: const Icon(Icons.music_note, color: Color.fromARGB(255, 30, 215, 96)),
                          ),
                          title: Text(
                            fav['title'],
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            fav['artist'],
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.favorite, color: Color.fromARGB(255, 30, 215, 96)),
                            onPressed: () => _removeFavorite(fav['title'], fav['artist']),
                          ),
                          onTap: () {
                            final song = Song(
                              title: fav['title'],
                              artist: fav['artist'],
                              url: fav['url'],
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayerScreen(songs: [song], initialIndex: 0),
                              ),
                            ).then((_) => _loadFavorites());
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
