import 'package:flutter/material.dart';
import '../services/db_service.dart';

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
    setState(() {
      favorites = data;
    });
  }

  Future<void> _addFavorite(String name) async {
    await DBService.insertFavorite(name);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {

    final String? playlist =
    ModalRoute.of(context)?.settings.arguments as String?;

    if (playlist != null) {
      _addFavorite(playlist);
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Favorites"),
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Text(
          "No favorites yet",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              favorites[index]['name'],
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}