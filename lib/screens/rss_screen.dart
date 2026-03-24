import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';

class RSSScreen extends StatefulWidget {
  const RSSScreen({super.key});

  @override
  State<RSSScreen> createState() => _RSSScreenState();
}

class _RSSScreenState extends State<RSSScreen> {
  late Future<List<dynamic>> _stationsFuture;
  final AudioPlayer _player = AudioPlayer();
  int? _playingIndex;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _stationsFuture = fetchStations();
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() => _isPlaying = state == PlayerState.playing);
      }
    });
  }

  Future<List<dynamic>> fetchStations() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://de1.api.radio-browser.info/json/stations/search?country=India&limit=30&hidebroken=true&order=clickcount&reverse=true',
        ),
        headers: {'User-Agent': 'SpotifyCloneApp/1.0'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Filter stations that have a valid stream URL
        return data
            .where((s) =>
                s['url_resolved'] != null &&
                s['url_resolved'].toString().isNotEmpty)
            .toList();
      } else {
        throw Exception("Failed to load stations");
      }
    } catch (e) {
      throw Exception("Failed to load stations: $e");
    }
  }

  Future<void> _playStation(String url, int index) async {
    if (_playingIndex == index && _isPlaying) {
      await _player.stop();
      setState(() {
        _playingIndex = null;
        _isPlaying = false;
      });
    } else {
      await _player.stop();
      await _player.play(UrlSource(url));
      setState(() => _playingIndex = index);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 215, 96),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Live Radio",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _stationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Color.fromARGB(255, 30, 215, 96)),
                  SizedBox(height: 16),
                  Text("Loading stations...", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, color: Colors.grey, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    "Could not load radio stations",
                    style: TextStyle(color: Colors.grey[400], fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _stationsFuture = fetchStations();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 30, 215, 96),
                    ),
                    child: const Text("Retry", style: TextStyle(color: Colors.black)),
                  ),
                ],
              ),
            );
          }

          final stations = snapshot.data!;

          if (stations.isEmpty) {
            return const Center(
              child: Text("No stations found", style: TextStyle(color: Colors.grey)),
            );
          }

          return ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              final station = stations[index];
              final isCurrentPlaying = _playingIndex == index && _isPlaying;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isCurrentPlaying
                      ? const Color.fromARGB(255, 30, 215, 96)
                      : Colors.grey[850],
                  child: Icon(
                    isCurrentPlaying ? Icons.radio : Icons.radio_outlined,
                    color: isCurrentPlaying ? Colors.black : const Color.fromARGB(255, 30, 215, 96),
                  ),
                ),
                title: Text(
                  station['name'] ?? "Unknown",
                  style: TextStyle(
                    color: isCurrentPlaying
                        ? const Color.fromARGB(255, 30, 215, 96)
                        : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  station['tags'] ?? station['country'] ?? "",
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: Icon(
                    isCurrentPlaying ? Icons.stop_circle : Icons.play_circle_fill,
                    color: const Color.fromARGB(255, 30, 215, 96),
                    size: 36,
                  ),
                  onPressed: () => _playStation(station['url_resolved'], index),
                ),
                onTap: () => _playStation(station['url_resolved'], index),
              );
            },
          );
        },
      ),
    );
  }
}
