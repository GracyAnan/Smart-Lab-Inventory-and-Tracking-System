import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BorrowedItemsPage extends StatefulWidget {
  const BorrowedItemsPage({super.key});

  @override
  State<BorrowedItemsPage> createState() => _BorrowedItemsPageState();
}

class _BorrowedItemsPageState extends State<BorrowedItemsPage> {
  final DatabaseReference _studentsRef =
      FirebaseDatabase.instance.ref().child('students');

  // 🔹 Local fallback map (ID → Name)
  final Map<String, String> idToName = {
    "4d59b240": "Jeyashri.S",
    "c1c51cda": "Gracy Ananthika. D",
    "c328c12c": "Unknown",
    "f19751df": "Subha",
    "fe9916aa":"Lakshnya",
    "f7abeccb": "Shanmitha",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Borrowed Items")),
      body: StreamBuilder(
        stream: _studentsRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
            return const Center(child: Text("No borrowed items found."));
          }

          final data =
              Map<String, dynamic>.from(snapshot.data!.snapshot.value as Map);

          final borrowedItems = data.entries.map((e) {
            final item = Map<String, dynamic>.from(e.value);
            final id = e.key;
            return {
              "id": id,
              "name": item["name"] ?? idToName[id] ?? "Unknown",
              "status": item["status"] ?? "N/A",
              "current_weight": item["current_weight"] ?? 0,
              "weight_not_checked": item["weight_not_checked"] ?? false,
            };
          }).toList();

          return ListView.builder(
            itemCount: borrowedItems.length,
            itemBuilder: (context, index) {
              final item = borrowedItems[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blueAccent),
                  title: Text(
                    "Name: ${item['name']}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Student ID: ${item['id']}"),
                      Text("Status: ${item['status']}"),
                      Text("Returned Weight: ${item['returned_weight']} g"),
                    ],
                  ),
                  // Removed trailing text
                ),
              );
            },
          );
        },
      ),
    );
  }
}
