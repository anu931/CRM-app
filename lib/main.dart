import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'incoming_call.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebSocketChannel _ws;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _ws = WebSocketChannel.connect(
      Uri.parse('wss://margit-semisentimental-latonya.ngrok-free.dev/ws/call'),
    );
    _ws.stream.listen((msg) {
      if (msg == 'incoming_call') _openCall();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _connected = true);
    });
  }

  void _openCall() => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const IncomingCallScreen()),
  );

  @override
  void dispose() {
    _ws.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Agent Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _connected ? Colors.green : Colors.red,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _connected ? 'Live' : 'Offline',
                  style: TextStyle(
                    color: _connected ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _openCall,
          icon: const Icon(Icons.call),
          label: const Text('Simulate Incoming Call'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ),
    );
  }
}
