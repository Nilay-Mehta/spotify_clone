import 'package:flutter/material.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final _formKey = GlobalKey<FormState>();
  int songs = 0;
  double avgDuration = 0;
  String? result;

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      double totalMinutes = songs * avgDuration;
      int hours = totalMinutes ~/ 60;
      int mins = (totalMinutes % 60).toInt();
      setState(() {
        result = "$hours hr $mins min";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 215, 96),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Listening Stats",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.analytics, color: Color.fromARGB(255, 30, 215, 96), size: 60),
              const SizedBox(height: 16),
              const Text(
                "Calculate Your Listening Time",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Number of Songs",
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.music_note, color: Color.fromARGB(255, 30, 215, 96)),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                validator: (value) => value == null || value.isEmpty ? "Enter number" : null,
                onSaved: (value) => songs = int.tryParse(value!) ?? 0,
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Avg Duration (minutes)",
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.timer, color: Color.fromARGB(255, 30, 215, 96)),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                validator: (value) => value == null || value.isEmpty ? "Enter duration" : null,
                onSaved: (value) => avgDuration = double.tryParse(value!) ?? 0,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 30, 215, 96),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text(
                    "Calculate",
                    style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (result != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color.fromARGB(255, 30, 215, 96), width: 1),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "Total Listening Time",
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        result!,
                        style: const TextStyle(
                          color: Color.fromARGB(255, 30, 215, 96),
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
