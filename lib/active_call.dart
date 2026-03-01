import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class ActiveCallScreen extends StatefulWidget {
  final String name, number;
  const ActiveCallScreen({super.key, required this.name, required this.number});
  @override
  State<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends State<ActiveCallScreen> {
  int _secs = 0;
  bool _recording = false;
  String? _savedPath;
  Timer? _timer;
  final AudioRecorder _recorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() => _secs++));
    _startRecording();
  }

  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) return;

    // Use external storage (visible in Files app under Music or Documents)
    Directory? dir;
    try {
      dir = await getExternalStorageDirectory(); // /storage/emulated/0/Android/data/com.example.call_agent_app/files
    } catch (_) {
      dir = await getApplicationDocumentsDirectory();
    }

    final path = '${dir!.path}/call_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);
    setState(() { _recording = true; _savedPath = path; });
    debugPrint('🔴 Recording to: $path');
  }

  Future<void> _stopRecording() async {
    await _recorder.stop();
    setState(() => _recording = false);
    debugPrint('✅ Saved: $_savedPath');
  }

  Future<void> _endCall() async {
    await _stopRecording();
    if (mounted) Navigator.popUntil(context, (r) => r.isFirst);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  String get _time =>
    '${(_secs ~/ 60).toString().padLeft(2, '0')}:${(_secs % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.person, size: 80, color: Colors.white38),
        const SizedBox(height: 12),
        Text(widget.name, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
        Text(widget.number, style: const TextStyle(color: Colors.white54)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (_recording)
            Container(width: 8, height: 8, margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red)),
          Text(_time, style: const TextStyle(color: Colors.green, fontSize: 22, fontFamily: 'monospace')),
          if (_recording)
            const Text('  REC', style: TextStyle(color: Colors.red, fontSize: 12)),
        ]),
        if (_savedPath != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text('📁 $_savedPath',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white24, fontSize: 10)),
          ),
        ],
        const SizedBox(height: 56),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _btn(
            _recording ? Icons.stop : Icons.fiber_manual_record,
            _recording ? 'Stop Rec' : 'Record',
            _recording ? Colors.red : Colors.grey.shade900,
            _recording ? _stopRecording : _startRecording,
          ),
          const SizedBox(width: 60),
          _btn(Icons.call_end, 'End Call', Colors.red, _endCall),
        ]),
      ]),
    ),
  );

  Widget _btn(IconData icon, String label, Color color, VoidCallback onTap) =>
    Column(children: [
      GestureDetector(onTap: onTap,
        child: CircleAvatar(radius: 34, backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 28))),
      const SizedBox(height: 8),
      Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
    ]);
}