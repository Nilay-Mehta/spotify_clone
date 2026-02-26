import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RSSScreen extends StatefulWidget {
  const RSSScreen({super.key});

  @override
  State<RSSScreen> createState() => _RSSScreenState();
}

class _RSSScreenState extends State<RSSScreen> {

  Future<List<dynamic>> fetchStations() async {
    final response = await http.get(
      Uri.parse(
        'https://de1.api.radio-browser.info/json/stations/search?country=India&limit=20',
      ),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load stations");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 215, 96),
        title: const Text("Live Radio Stations"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchStations(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading stations",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final stations = snapshot.data!;

          return ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  stations[index]['name'] ?? "Unknown",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  stations[index]['country'] ?? "",
                  style: const TextStyle(color: Colors.grey),
                ),
                leading: const Icon(
                  Icons.radio,
                  color: Colors.green,
                ),
              );
            },
          );
        },
      ),
    );
  }
}