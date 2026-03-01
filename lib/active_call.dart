import 'dart:async';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class ActiveCallScreen extends StatefulWidget {
  const ActiveCallScreen({super.key});
  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  int _secs = 0;
  bool _recording = false;
  Timer? _timer;
  final AudioRecorder _recorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() => _secs++),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  String get _time =>
      '${(_secs ~/ 60).toString().padLeft(2, '0')}:${(_secs % 60).toString().padLeft(2, '0')}';

  Future<void> _toggleRecording() async {
    if (_recording) {
      await _recorder.stop();
      setState(() => _recording = false);
    } else {
      if (!await _recorder.hasPermission()) return;
      final dir = await getTemporaryDirectory();
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: '${dir.path}/call_${DateTime.now().millisecondsSinceEpoch}.m4a',
      );
      setState(() => _recording = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 80, color: Colors.white38),
            const SizedBox(height: 12),
            const Text(
              'Customer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '+91 9990000888',
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 8),
            Text(
              _time,
              style: const TextStyle(
                color: Colors.green,
                fontSize: 22,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 56),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _btn(
                  _recording ? Icons.stop : Icons.fiber_manual_record,
                  _recording ? 'Stop Rec' : 'Record',
                  _recording ? Colors.red : Colors.grey.shade900,
                  _toggleRecording,
                ),
                const SizedBox(width: 60),
                _btn(
                  Icons.call_end,
                  'End Call',
                  Colors.red,
                  () => Navigator.popUntil(context, (r) => r.isFirst),
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
              child: Icon(icon, color: Colors.white, size: 28),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      );
}
