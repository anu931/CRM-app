import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'incoming_call.dart';
import 'call_log.dart';

const kWs = 'wss://margit-semisentimental-latonya.ngrok-free.dev/ws/call';
final streamCtrl = StreamController<String>.broadcast();

void main() {
  WebSocketChannel.connect(Uri.parse(kWs)).stream
      .listen((m) => streamCtrl.add(m.toString()));
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: Home()));
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) setState(() => _connected = true);
    });

    streamCtrl.stream.listen((msg) {
      if (!mounted) return;
      if (msg.startsWith('incoming_call')) {
        // Format: incoming_call:name:number:message:date:time
        final p = msg.split(':');
        final name    = p.length > 1 ? p[1] : 'Customer';
        final number  = p.length > 2 ? p[2] : 'Unknown';
        final message = p.length > 3 ? p[3] : '';
        final date    = p.length > 4 ? p[4] : '';
        final time    = p.length > 5 ? p[5] : '';
        _openIncoming(name: name, number: number, message: message, date: date, time: time);
      }
    });
  }

  void _openIncoming({
    required String name,
    required String number,
    String message = '',
    String date = '',
    String time = '',
  }) {
    // Save to call log immediately
    final now = DateTime.now();
    saveCallEntry(CallEntry(
      name: name,
      number: number,
      message: message,
      date: date.isNotEmpty ? date : '${now.day.toString().padLeft(2,'0')}-${now.month.toString().padLeft(2,'0')}-${now.year.toString().substring(2)}',
      time: time.isNotEmpty ? time : '${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}',
    ));

    Navigator.push(context, MaterialPageRoute(
      builder: (_) => IncomingCallScreen(name: name, number: number),
    ));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: const Text('Agent Dashboard', style: TextStyle(color: Colors.white)),
      actions: [
        Row(children: [
          Container(width: 10, height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _connected ? Colors.green : Colors.red,
            )),
          const SizedBox(width: 6),
          Text(_connected ? 'Live' : 'Offline',
            style: TextStyle(color: _connected ? Colors.green : Colors.red)),
          const SizedBox(width: 16),
        ]),
      ],
    ),
    body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.call),
          label: const Text('Simulate Call'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(200, 48),
          ),
          onPressed: () => _openIncoming(name: 'Test User', number: '+91 9990000888'),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          icon: const Icon(Icons.list_alt),
          label: const Text('Call Log'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A1A),
            minimumSize: const Size(200, 48),
          ),
          onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CallLogScreen())),
        ),
      ]),
    ),
  );
}