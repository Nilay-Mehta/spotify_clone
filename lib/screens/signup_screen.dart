import 'package:flutter/material.dart';
import '../services/db_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String password = "";
  String confirmPassword = "";
  bool _loading = false;

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (password.length < 4) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password must be at least 4 characters"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _loading = true);
      final success = await DBService.registerUser(username, password);
      setState(() => _loading = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration Successful! Please login."),
            backgroundColor: Color.fromARGB(255, 30, 215, 96),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Username already exists"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: const Color.fromARGB(255, 30, 215, 96)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700]!),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromARGB(255, 30, 215, 96)),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.grey[900],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.music_note,
                  color: Color.fromARGB(255, 30, 215, 96),
                  size: 60,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Sign up to start listening",
                  style: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
                const SizedBox(height: 40),

                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Username", Icons.person),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter username" : null,
                  onSaved: (value) => username = value!,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Password", Icons.lock),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Enter password" : null,
                  onSaved: (value) => password = value!,
                ),

                const SizedBox(height: 16),

                TextFormField(
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration("Confirm Password", Icons.lock_outline),
                  validator: (value) =>
                      value == null || value.isEmpty ? "Confirm password" : null,
                  onSaved: (value) => confirmPassword = value!,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 30, 215, 96),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                          )
                        : const Text(
                            "SIGN UP",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: Colors.grey[400]),
                      children: const [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            color: Color.fromARGB(255, 30, 215, 96),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
