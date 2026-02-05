import 'package:flutter/material.dart';
import 'students_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // 🔹 Define your static ID–Name map here (same one used in BorrowedItemsPage)
    final Map<String, String> idToName = {
      "4d59b240": "Jeyashri.S",
      "c1c51cda": "Gracy Ananthika. D",
      "c328c12c": "Kavya Lakshmi ",
      "f19751df": "Subha",
      "fe9916aa":"Lakshnya",
      "f7abeccb": "Shanmitha",
    };

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            // 🔹 Registered Students Button
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StudentsPage(idToName: idToName),
                  ),
                );
              },
              child: Card(
                color: Colors.blueAccent.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: const Center(
                  child: Text(
                    "📋 Registered Students",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),

            // 🔹 Borrowed Items Button
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/borrowed');
              },
              child: Card(
                color: Colors.green.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: const Center(
                  child: Text(
                    "📦 Borrowed Items",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
