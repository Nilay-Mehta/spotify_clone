import 'package:flutter/material.dart';
import '../models/song.dart';
import '../widgets/playlist_card.dart';
import 'playlist_screen.dart';
import 'favorites_screen.dart';
import 'rss_screen.dart';
import 'login_screen.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<String> playlists = [
    "Top Hits",
    "Chill Vibes",
    "Workout Mix",
    "Focus Flow",
  ];

  Widget _buildHome() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Center(
            child: Text(
              "Your Music. Your Mood.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Color.fromARGB(255, 30, 215, 96),
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Playlists",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              itemCount: playlists.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaylistScreen(playlistName: playlists[index]),
                      ),
                    );
                  },
                  child: PlaylistCard(title: playlists[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Quick Play",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: allSongs.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          songs: allSongs,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          allSongs[index].title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          allSongs[index].artist,
                          style: TextStyle(color: Colors.grey[500], fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Search",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Songs, artists...",
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (query) {
              setState(() {
                _searchQuery = query.toLowerCase();
              });
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredSongs.length,
              itemBuilder: (context, index) {
                final song = _filteredSongs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[850],
                    child: const Icon(Icons.music_note, color: Color.fromARGB(255, 30, 215, 96)),
                  ),
                  title: Text(song.title, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(song.artist, style: TextStyle(color: Colors.grey[500])),
                  trailing: const Icon(Icons.play_circle_fill, color: Color.fromARGB(255, 30, 215, 96)),
                  onTap: () {
                    final songIndex = allSongs.indexOf(song);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerScreen(
                          songs: allSongs,
                          initialIndex: songIndex >= 0 ? songIndex : 0,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _searchQuery = "";

  List<Song> get _filteredSongs {
    if (_searchQuery.isEmpty) return allSongs;
    return allSongs
        .where((s) =>
            s.title.toLowerCase().contains(_searchQuery) ||
            s.artist.toLowerCase().contains(_searchQuery))
        .toList();
  }

  Widget _buildLibrary() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Library",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildLibraryTile(Icons.favorite, "Liked Songs", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritesScreen()),
            );
          }),
          _buildLibraryTile(Icons.radio, "Live Radio", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RSSScreen()),
            );
          }),
          const Divider(color: Colors.grey),
          const SizedBox(height: 8),
          const Text(
            "Playlists",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 8),
          ...playlists.map((name) => _buildLibraryTile(Icons.queue_music, name, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlaylistScreen(playlistName: name)),
            );
          })),
        ],
      ),
    );
  }

  Widget _buildLibraryTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 30, 215, 96)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bodies = [_buildHome(), _buildSearch(), _buildLibrary()];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 215, 96),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Spotify",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),

      drawer: Drawer(
        backgroundColor: Colors.grey[900],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 30, 215, 96),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.music_note, color: Colors.white, size: 40),
                  SizedBox(height: 8),
                  Text(
                    "Spotify Clone",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Your Music. Your Mood.",
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.white),
              title: const Text("Home", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                setState(() => _selectedIndex = 0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.white),
              title: const Text("Favorites", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritesScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.radio, color: Colors.white),
              title: const Text("Live Radio", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RSSScreen()),
                );
              },
            ),
            const Divider(color: Colors.grey),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Logout", style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: bodies[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: const Color.fromARGB(255, 30, 215, 96),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: "Library"),
        ],
      ),
    );
  }
}
