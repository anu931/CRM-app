import 'package:flutter/material.dart';
import 'active_call.dart';

class IncomingCallScreen extends StatelessWidget {
  const IncomingCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 90, color: Colors.white38),
            const SizedBox(height: 16),
            const Text(
              'Customer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              '+91 9990000888',
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Incoming call...',
              style: TextStyle(color: Colors.green),
            ),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _btn(
                  Icons.call_end,
                  'Decline',
                  Colors.red,
                  () => Navigator.pop(context),
                ),
                const SizedBox(width: 60),
                _btn(
                  Icons.call,
                  'Accept',
                  Colors.green,
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ActiveCallScreen()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _btn(IconData icon, String label, Color color, VoidCallback onTap) =>
      Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 34,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 30),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.white54)),
        ],
      );
}
