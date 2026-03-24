import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final String title;

  const PlaylistCard({super.key, required this.title});

  IconData get _icon {
    switch (title) {
      case "Top Hits":
        return Icons.star;
      case "Chill Vibes":
        return Icons.spa;
      case "Workout Mix":
        return Icons.fitness_center;
      case "Focus Flow":
        return Icons.headphones;
      default:
        return Icons.music_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[850]!,
            Colors.grey[900]!,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            _icon,
            color: const Color.fromARGB(255, 30, 215, 96),
            size: 32,
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tap to play",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
