import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

// ignore: deprecated_member_use
/// Only import dart:html on web
/// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class StudentsPage extends StatefulWidget {
  final Map<String, String> idToName;

  const StudentsPage({super.key, required this.idToName});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final DatabaseReference _studentsRef =
      FirebaseDatabase.instance.ref().child('students');

  List<String> studentsList = [];

  /// Get platform-specific path for mobile
  Future<String> getSavePath() async {
    String folderPath;

    if (defaultTargetPlatform == TargetPlatform.android) {
      folderPath = '/storage/emulated/0/Download/attendance';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // iOS sandbox Documents folder
      final directory = Directory(
          (await Directory.systemTemp.createTemp()).path); // fallback
      folderPath = '${directory.path}/attendance';
    } else {
      // Desktop fallback
      final directory = Directory.systemTemp;
      folderPath = '${directory.path}/attendance';
    }

    final dir = Directory(folderPath);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }

    return folderPath;
  }

  /// Web CSV download
  void downloadCSVWeb(String csvContent) {
    final bytes = utf8.encode(csvContent);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "students_list.csv")
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  /// Main CSV download function
  Future<void> downloadCSV() async {
    if (studentsList.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No students to download.")),
      );
      return;
    }

    final csv = "Student Name\n" + studentsList.join('\n');

    try {
      if (kIsWeb) {
        // Web download
        downloadCSVWeb(csv);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("CSV downloaded in browser.")),
        );
      } else {
        // Mobile download
        final folderPath = await getSavePath();
        final filePath = '$folderPath/students_list.csv';
        final file = File(filePath);
        await file.writeAsString(csv);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Downloaded successfully at $filePath")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving file: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registered Students"),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: downloadCSV,
          ),
        ],
      ),
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
            studentsList = [];
            return const Center(child: Text("No students found."));
          }

          final data = Map<String, dynamic>.from(
            snapshot.data!.snapshot.value as Map<dynamic, dynamic>,
          );

          studentsList = data.entries.map<String>((e) {
            final id = e.key.toString();
            final student = Map<String, dynamic>.from(e.value);
            return widget.idToName[id] ?? student["name"]?.toString() ?? "Unknown";
          }).toList();

          return ListView.builder(
            itemCount: studentsList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.person, color: Colors.blueAccent),
                title: Text(
                  studentsList[index],
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
