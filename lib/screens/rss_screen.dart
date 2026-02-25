import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RSSScreen extends StatefulWidget {
  const RSSScreen({super.key});

  @override
  State<RSSScreen> createState() => _RSSScreenState();
}

class _RSSScreenState extends State<RSSScreen> {

  Future<List<dynamic>> fetchFeed() async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load feed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Music Feed"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchFeed(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading feed",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final data = snapshot.data!;

          return ListView.builder(
            itemCount: 15,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  data[index]['title'],
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  data[index]['body'],
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 2,
                ),
              );
            },
          );
        },
      ),
    );
  }
}