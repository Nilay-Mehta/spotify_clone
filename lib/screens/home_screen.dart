import 'package:flutter/material.dart';
import '../widgets/playlist_card.dart';
import 'stats_screen.dart';
import 'visualizer_screen.dart';
import 'favorites_screen.dart';
import 'rss_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _selectedIndex = 0;
  String nowPlaying = "Chill Vibes";

  final List<String> playlists = [
    "Top Hits",
    "Chill Vibes",
    "Workout Mix",
    "Focus Flow",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ✅ Experiment 3 AppBar
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 215, 96),
        title: const Text(
          "Spotify",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => StatsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.graphic_eq),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VisualizerScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.rss_feed),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RSSScreen()),
              );
            },
          ),
        ],
      ),

      // ✅ Drawer with Favorites
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 30, 215, 96),
              ),
              child: Text(
                "Spotify App",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favorites"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      body: Padding(
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
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Recently Played",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: playlists.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        nowPlaying = playlists[index];
                      });
                    },
                    child: PlaylistCard(
                      title: playlists[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomSheet: Container(
        height: 60,
        color: Colors.grey[900],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                "Now Playing: $nowPlaying",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: "Library",
          ),
        ],
      ),
    );
  }
}