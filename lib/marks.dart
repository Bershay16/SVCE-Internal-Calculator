import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MarksDisplayWidget extends StatefulWidget {
  const MarksDisplayWidget({super.key});

  @override
  _MarksDisplayWidgetState createState() => _MarksDisplayWidgetState();
}

class _MarksDisplayWidgetState extends State<MarksDisplayWidget> {
  Map<String, String> marks = {};

  @override
  void initState() {
    super.initState();
    _loadMarks();
  }

  Future<void> _loadMarks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final Map<String, String> loadedMarks = {};
    for (String key in keys) {
      loadedMarks[key] = prefs.getString(key) ?? '';
    }
    setState(() {
      marks = loadedMarks;
    });
  }

  Future<void> _deleteMark(String subjectName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(subjectName);
    setState(() {
      marks.remove(subjectName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marks"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: marks.isEmpty
          ? const Center(
              child: Text(
                "No Marks Added",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              itemCount: marks.length,
              itemBuilder: (context, index) {
                final subjectName = marks.keys.elementAt(index);
                final subjectMark = marks[subjectName]!;
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      subjectName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Mark: $subjectMark",
                      style: const TextStyle(fontSize: 14),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteMark(subjectName);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
