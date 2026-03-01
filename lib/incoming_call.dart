import 'package:flutter/material.dart';
import 'active_call.dart';

class IncomingCallScreen extends StatelessWidget {
  final String name, number;
  const IncomingCallScreen({super.key, required this.name, required this.number});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.person, size: 90, color: Colors.white38),
        const SizedBox(height: 16),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(number, style: const TextStyle(color: Colors.white54, fontSize: 16)),
        const SizedBox(height: 8),
        const Text('Incoming call...', style: TextStyle(color: Colors.green)),
        const SizedBox(height: 60),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _btn(Icons.call_end, 'Reject', Colors.red,
            () => Navigator.popUntil(context, (r) => r.isFirst)),
          const SizedBox(width: 60),
          _btn(Icons.call, 'Accept', Colors.green,
            () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => ActiveCallScreen(name: name, number: number)))),
        ]),
      ]),
    ),
  );

  Widget _btn(IconData icon, String label, Color color, VoidCallback onTap) =>
    Column(children: [
      GestureDetector(onTap: onTap,
        child: CircleAvatar(radius: 34, backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 30))),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(color: Colors.white54)),
    ]);
}