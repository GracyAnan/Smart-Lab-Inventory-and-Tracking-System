import 'package:flutter/material.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy alerts data
    final List<Map<String, String>> alerts = [
      {"message": "Box B101 weight mismatch detected!", "student": "Gracy"},
      {"message": "Unauthorized access attempt at Box B103", "student": "Jeyashri"},
      {"message": "Box B104 not returned on time", "student": "Kavya Lakshmi"},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Alerts")),
      body: ListView.builder(
        itemCount: alerts.length,
        itemBuilder: (context, index) {
          final alert = alerts[index];
          return Card(
            color: Colors.red,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: Text(alert["message"]!),
              subtitle: Text("Student: ${alert["student"]}"),
            ),
          );
        },
      ),
    );
  }
}
