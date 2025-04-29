import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InfoTask extends StatefulWidget {
  final String taskId;
  const InfoTask({super.key, required this.taskId});

  @override
  State<InfoTask> createState() => _InfoTaskState();
}

class _InfoTaskState extends State<InfoTask>
    with SingleTickerProviderStateMixin {
  DocumentSnapshot? task;
  DocumentSnapshot? project;
  bool isLoading = true;
  String errorMessage = '';
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    fetchTaskAndProject();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchTaskAndProject() async {
    try {
      var taskDoc = await FirebaseFirestore.instance
          .collection('Task')
          .doc(widget.taskId)
          .get();

      if (!taskDoc.exists) {
        throw Exception('Task not found');
      }

      var projectDoc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(taskDoc['id_project'])
          .get();

      if (!projectDoc.exists) {
        throw Exception('Project not found');
      }

      setState(() {
        task = taskDoc;
        project = projectDoc;
        isLoading = false;
        errorMessage = '';
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> updateTaskStatus(String status) async {
    try {
      await FirebaseFirestore.instance
          .collection('Task')
          .doc(widget.taskId)
          .update({'etat': status});
      fetchTaskAndProject();
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }
  

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Task"),
        backgroundColor: Color.fromARGB(255, 137, 92, 164),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text('Error: $errorMessage'))
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 132, 220, 211),
                        Color.fromARGB(255, 137, 92, 164),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: EdgeInsets.all(20),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Title task: ${task!['title']}",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 153, 81, 166)),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Start Date: ${formatDate(task!['dateStart'])}",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "End Date: ${formatDate(task!['dateFin'])}",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Description: ${task!['description']}",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Status: ${task!['etat']}",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Project: ${project!['title']}",
                                style: TextStyle(fontSize: 20),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () => updateTaskStatus("debut"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 137, 92, 164),
                                    ),
                                    child: Text(
                                      "Debut",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        updateTaskStatus("   fin   "),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromARGB(255, 137, 92, 164),
                                    ),
                                    child: Text(
                                      "Fin",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
