import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song.dart';
import '../services/db_service.dart';

class PlayerScreen extends StatefulWidget {
  final List<Song> songs;
  final int initialIndex;

  const PlayerScreen({
    super.key,
    required this.songs,
    required this.initialIndex,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late AudioPlayer _player;
  late int _currentIndex;
  bool _isPlaying = false;
  bool _isFavorite = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  Song get _currentSong => widget.songs[_currentIndex];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _currentIndex = widget.initialIndex;
    _setupPlayer();
    _playSong();
  }

  void _setupPlayer() {
    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _player.onPlayerComplete.listen((_) {
      _next();
    });
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  Future<void> _playSong() async {
    await _player.stop();
    await _player.play(UrlSource(_currentSong.url));
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final fav = await DBService.isFavorite(_currentSong.title, _currentSong.artist);
    if (mounted) setState(() => _isFavorite = fav);
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await DBService.removeFavorite(_currentSong.title, _currentSong.artist);
    } else {
      await DBService.insertFavorite(_currentSong.title, _currentSong.artist, _currentSong.url);
    }
    _checkFavorite();
  }

  void _next() {
    if (_currentIndex < widget.songs.length - 1) {
      setState(() => _currentIndex++);
      _playSong();
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _playSong();
    }
  }

  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Now Playing",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Spacer(),

            // Album art placeholder
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.music_note,
                color: Color.fromARGB(255, 30, 215, 96),
                size: 120,
              ),
            ),

            const SizedBox(height: 40),

            // Song title
            Text(
              _currentSong.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _currentSong.artist,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            // Seek bar
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: const Color.fromARGB(255, 30, 215, 96),
                inactiveTrackColor: Colors.grey[800],
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 3,
              ),
              child: Slider(
                min: 0,
                max: _duration.inSeconds.toDouble().clamp(1, double.infinity),
                value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble().clamp(1, double.infinity)),
                onChanged: (value) {
                  _player.seek(Duration(seconds: value.toInt()));
                },
              ),
            ),

            // Duration labels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_position), style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  Text(_formatDuration(_duration), style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Favorite button
                IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? const Color.fromARGB(255, 30, 215, 96) : Colors.white,
                  ),
                  iconSize: 28,
                  onPressed: _toggleFavorite,
                ),
                const SizedBox(width: 16),
                // Previous
                IconButton(
                  icon: const Icon(Icons.skip_previous, color: Colors.white),
                  iconSize: 40,
                  onPressed: _previous,
                ),
                const SizedBox(width: 8),
                // Play/Pause
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 30, 215, 96),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                    ),
                    iconSize: 48,
                    onPressed: () {
                      if (_isPlaying) {
                        _player.pause();
                      } else {
                        _player.resume();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                // Next
                IconButton(
                  icon: const Icon(Icons.skip_next, color: Colors.white),
                  iconSize: 40,
                  onPressed: _next,
                ),
                const SizedBox(width: 16),
                // Shuffle (decorative)
                IconButton(
                  icon: const Icon(Icons.shuffle, color: Colors.white),
                  iconSize: 28,
                  onPressed: () {},
                ),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
