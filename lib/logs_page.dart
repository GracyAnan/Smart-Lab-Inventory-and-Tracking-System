import 'package:flutter/material.dart';

class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy logs data
    final List<Map<String, String>> logs = [
      {"action": "Login", "user": "Admin1", "time": "2025-09-21 10:15 AM"},
      {"action": "Box B102 borrowed", "user": "Jeyashri", "time": "2025-09-21 11:00 AM"},
      {"action": "Box B102 returned", "user": "Jeyashri", "time": "2025-09-21 01:20 PM"},
      {"action": "Alert generated", "user": "Gracy", "time": "2025-09-21 02:00 PM"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Logs")),
      body: ListView.builder(
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.history, color: Colors.blueGrey),
              title: Text("${log["action"]} by ${log["user"]}"),
              subtitle: Text("Time: ${log["time"]}"),
            ),
          );
        },
      ),
    );
  }
}
