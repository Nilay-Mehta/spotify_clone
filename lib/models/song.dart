class Song {
  final String title;
  final String artist;
  final String url;

  const Song({
    required this.title,
    required this.artist,
    required this.url,
  });
}

// Free sample songs (public domain / creative commons audio URLs)
const List<Song> allSongs = [
  Song(
    title: "Acoustic Breeze",
    artist: "Bensound",
    url: "https://www.bensound.com/bensound-music/bensound-acousticbreeze.mp3",
  ),
  Song(
    title: "Sunny",
    artist: "Bensound",
    url: "https://www.bensound.com/bensound-music/bensound-sunny.mp3",
  ),
  Song(
    title: "Creative Minds",
    artist: "Bensound",
    url: "https://www.bensound.com/bensound-music/bensound-creativeminds.mp3",
  ),
  Song(
    title: "Tenderness",
    artist: "Bensound",
    url: "https://www.bensound.com/bensound-music/bensound-tenderness.mp3",
  ),
  Song(
    title: "Energy",
    artist: "Bensound",
    url: "https://www.bensound.com/bensound-music/bensound-energy.mp3",
  ),
  Song(
    title: "Happy Rock",
    artist: "Bensound",
    url: "https://www.bensound.com/bensound-music/bensound-happyrock.mp3",
  ),
  Song(
    title: "Jazzy Frenchy",
    artist: "Bensound",
    url: "https://www.bensound.com/bensound-music/bensound-jazzyfrenchy.mp3",
  ),
  Song(
    title: "Little Idea",
    artist: "Bensound",
    url: "https://www.bensound.com/bensound-music/bensound-littleidea.mp3",
  ),
];

// Playlists mapped to songs
const Map<String, List<int>> playlistSongs = {
  "Top Hits": [0, 1, 4, 5],
  "Chill Vibes": [0, 2, 3, 6],
  "Workout Mix": [4, 5, 7, 1],
  "Focus Flow": [2, 3, 6, 7],
};
