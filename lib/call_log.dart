import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallEntry {
  final String name, number, message, date, time;
  CallEntry({required this.name, required this.number, required this.message,
    required this.date, required this.time});

  Map toJson() => {'name': name, 'number': number, 'message': message,
    'date': date, 'time': time};

  factory CallEntry.fromJson(Map j) => CallEntry(
    name: j['name'] ?? '', number: j['number'] ?? '',
    message: j['message'] ?? '', date: j['date'] ?? '', time: j['time'] ?? '');
}

// ── Standalone save function (call from anywhere) ──
Future<void> saveCallEntry(CallEntry entry) async {
  final prefs = await SharedPreferences.getInstance();
  final data = prefs.getStringList('call_log') ?? [];
  data.insert(0, jsonEncode(entry.toJson()));
  await prefs.setStringList('call_log', data);
}

class CallLogScreen extends StatefulWidget {
  const CallLogScreen({super.key});
  @override
  State<CallLogScreen> createState() => _CallLogScreenState();
}

class _CallLogScreenState extends State<CallLogScreen> {
  List<CallEntry> _entries = [];

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('call_log') ?? [];
    setState(() => _entries = data.map((e) => CallEntry.fromJson(jsonDecode(e))).toList());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      backgroundColor: Colors.black,
      title: const Text('Call Log', style: TextStyle(color: Colors.white)),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    body: _entries.isEmpty
      ? const Center(child: Text('No call logs yet.', style: TextStyle(color: Colors.white38, fontSize: 15)))
      : Column(children: [
          Container(
            color: const Color(0xFF1A1A1A),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: const Row(children: [
              Expanded(flex: 2, child: Text('Name',     style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12))),
              Expanded(flex: 2, child: Text('Number',   style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12))),
              Expanded(flex: 3, child: Text('Message',  style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12))),
              Expanded(flex: 2, child: Text('Date/Time',style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12))),
            ]),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: _entries.length,
              separatorBuilder: (_, _) => const Divider(color: Colors.white12, height: 1),
              itemBuilder: (_, i) {
                final e = _entries[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(children: [
                    Expanded(flex: 2, child: Text(e.name,    style: const TextStyle(color: Colors.white, fontSize: 12))),
                    Expanded(flex: 2, child: Text(e.number,  style: const TextStyle(color: Colors.blue, fontSize: 12))),
                    Expanded(flex: 3, child: Text(e.message, style: const TextStyle(color: Colors.white70, fontSize: 12))),
                    Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(e.date, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                      Text(e.time, style: const TextStyle(color: Colors.white24, fontSize: 10)),
                    ])),
                  ]),
                );
              },
            ),
          ),
        ]),
  );
}