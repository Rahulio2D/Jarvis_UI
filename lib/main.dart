import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ApiResponseWidget(),
      ),
    );
  }
}

class ApiResponseWidget extends StatefulWidget {
  @override
  State<ApiResponseWidget> createState() => _ApiResponseWidgetState();
}

class _ApiResponseWidgetState extends State<ApiResponseWidget> {
  String apiResponse = 'Waiting for your command, sir.';
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() async {
    setState(() {
      apiResponse = 'Loading...'; // Simulate loading
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/queries'), // Placeholder endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'data': {'type': 'query', 'attributes': {'query': _controller.text}}}),
      );

      setState(() {
        apiResponse = response.body;
        // _controller.clear();
      });
    } catch (e) {
      setState(() {
        apiResponse = e.toString();
        // _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 192, 191, 191),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              apiResponse,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Flexible(
                flex: 9,
                child: TextField(
                  controller: _controller,
                  minLines: 1,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
