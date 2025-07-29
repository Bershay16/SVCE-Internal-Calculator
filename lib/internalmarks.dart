import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internal_calculator/marks.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveMark(String subjectName, String subjectMark) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Store the mark using the subject name as the key
  await prefs.setString(subjectName, subjectMark);

  //print('Saved: $subjectName - $subjectMark');
}

class MarksCalculator extends StatefulWidget {
  static double internalMarks = 0.00;

  const MarksCalculator({super.key});

  @override
  _MarksCalculatorState createState() => _MarksCalculatorState();
}

class _MarksCalculatorState extends State<MarksCalculator> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cat1Controller = TextEditingController();
  final TextEditingController cat2Controller = TextEditingController();
  final TextEditingController cat3Controller = TextEditingController();
  final TextEditingController assignment1Controller = TextEditingController();
  final TextEditingController assignment2Controller = TextEditingController();
  final TextEditingController assignment3Controller = TextEditingController();

  bool isCelebrating = false;

  void calculateInternalMarks() {
    if (_formKey.currentState!.validate()) {
      int cat1 = int.tryParse(cat1Controller.text) ?? 0;
      int cat2 = int.tryParse(cat2Controller.text) ?? 0;
      int cat3 = int.tryParse(cat3Controller.text) ?? 0;
      int assignment1 = int.tryParse(assignment1Controller.text) ?? 0;
      int assignment2 = int.tryParse(assignment2Controller.text) ?? 0;
      int assignment3 = int.tryParse(assignment3Controller.text) ?? 0;

      double totalCats = (cat1 + cat2 + cat3) * 0.7;
      double totalAssignments = (assignment1 + assignment2 + assignment3) * 0.3;
      MarksCalculator.internalMarks =
          ((totalCats + totalAssignments) / 3) * 0.8;

      setState(() {
        isCelebrating = true;
      });
    }
  }

  Widget buildTextField(
      String label, TextEditingController controller, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a value';
          }
          final val = int.tryParse(value);
          if (val == null || val < 0 || val > 50) {
            return 'Marks should be between 0 and 50';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: color),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Internal Marks Calculator'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue[25],
              child: Stack(
                children: [
                  Opacity(
                    opacity: isCelebrating ? 0.3 : 1.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            buildTextField("Enter CAT1 marks", cat1Controller,
                                Colors.blueAccent),
                            buildTextField("Enter CAT2 marks", cat2Controller,
                                Colors.blueAccent),
                            buildTextField("Enter CAT3 marks", cat3Controller,
                                Colors.blueAccent),
                            buildTextField("Enter Assignment1 marks",
                                assignment1Controller, Colors.purple),
                            buildTextField("Enter Assignment2 marks",
                                assignment2Controller, Colors.purple),
                            buildTextField("Enter Assignment3 marks",
                                assignment3Controller, Colors.purple),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                 
                                calculateInternalMarks();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                  ),
                                ),
                              ),
                              label: const Text("Calculate"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                 
                                showCustomDialog(context, onSave: (data) {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.pinkAccent,
                                foregroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(50),
                                    bottomLeft: Radius.circular(50),
                                    bottomRight: Radius.circular(50),
                                  ),
                                ),
                              ),
                              label: const Text("Save Mark"),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (isCelebrating)
                    CelebrationScreen(onDismiss: () {
                      setState(() {
                        isCelebrating = false;
                      });
                    }),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: const Center(
              child: Text(
                '© Created by Bershay',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          
          Get.to(
            () => const MarksDisplayWidget(),
            transition: Transition.cupertino,
            duration: const Duration(milliseconds: 600),
          );
        },
        shape: const CircleBorder(),
        elevation: 1,
        child: const Icon(
          Icons.school,
          size: 40,
        ),
      ),
    );
  }
}

class CelebrationScreen extends StatefulWidget {
  final VoidCallback onDismiss;

  const CelebrationScreen({super.key, required this.onDismiss});

  @override
  _CelebrationScreenState createState() => _CelebrationScreenState();
}

class _CelebrationScreenState extends State<CelebrationScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 5));

    // Start the confetti burst
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Confetti burst animation
        Center(
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive, // Explosion effect
            numberOfParticles: 30,
            gravity: 0.1,
          ),
        ),
        
        // Your content
        Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Internal Marks: ${MarksCalculator.internalMarks.toStringAsFixed(2)} / 40",
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                GestureDetector(
                  onTap: widget.onDismiss,
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.purple]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        "Done",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


void showCustomDialog(BuildContext context,
    {required ValueChanged<Map<String, String>> onSave}) {
  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController subjectMarkController = TextEditingController();

  showGeneralDialog(
    context: context,
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: 300,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(0, 10),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: subjectNameController,
                  decoration: const InputDecoration(
                      labelText: "Subject Name",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.blueAccent)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: subjectMarkController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Subject Mark",
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.blueAccent)),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final String subjectName =
                        subjectNameController.text.trim();
                    final String subjectMark =
                        subjectMarkController.text.trim();

                    if (subjectName.isNotEmpty && subjectMark.isNotEmpty) {
                      await saveMark(subjectName, subjectMark);
                      onSave({
                        "subjectName": subjectName,
                        "subjectMark": subjectMark,
                      });
                      subjectNameController.clear();
                      subjectMarkController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please fill in both fields!")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                  child: const Text("Save Mark"),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: anim, curve: Curves.easeInOut)),
        child: child,
      );
    },
  );
}
