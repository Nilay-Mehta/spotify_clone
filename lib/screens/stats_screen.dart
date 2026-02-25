import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController songsController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  String result = "";

  void calculateTime() {
    if (_formKey.currentState!.validate()) {
      int songs = int.parse(songsController.text);
      int duration = int.parse(durationController.text);

      int totalMinutes = songs * duration;

      setState(() {
        result = "Total Listening Time: $totalMinutes minutes";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Music Stats"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: songsController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Number of Songs",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter number of songs" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Average Duration (minutes)",
                  labelStyle: TextStyle(color: Colors.white),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Enter duration" : null,
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: calculateTime,
                child: const Text("Calculate"),
              ),

              const SizedBox(height: 30),

              Text(
                result,
                style: const TextStyle(color: Colors.green, fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}