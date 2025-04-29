import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/BodyApp/creat_Task.dart';
import 'package:flutter/material.dart';

class InfoProject extends StatefulWidget {
  final String idProject;
  const InfoProject({Key? key, required this.idProject}) : super(key: key);

  @override
  State<InfoProject> createState() => _InfoProjectState();
}

class _InfoProjectState extends State<InfoProject>
    with SingleTickerProviderStateMixin {
  late Future<DocumentSnapshot> projectData;
  late Future<List<QueryDocumentSnapshot>> tasksData;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    projectData = getProjectData();
    tasksData = getTasksData();

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

  Future<DocumentSnapshot> getProjectData() async {
    return await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.idProject)
        .get();
  }

  Future<List<QueryDocumentSnapshot>> getTasksData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Task')
        .where('id_project', isEqualTo: widget.idProject)
        .get();
    return querySnapshot.docs;
  }

  String formatDate(String dateStr) {
    DateTime date = DateTime.parse(dateStr);
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Details'),
        backgroundColor: Color.fromARGB(255, 137, 92, 164),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Creat_task(task_project: widget.idProject)));
        },
        backgroundColor: Color.fromARGB(255, 137, 92, 164),
        child: Icon(Icons.add),
      ),
      body: Container(
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
        child: Column(
          children: [
            // Project info
            FutureBuilder<DocumentSnapshot>(
              future: projectData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text('Project not found');
                } else {
                  var project = snapshot.data!.data() as Map<String, dynamic>;
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 30),
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
                            "Project Description: ${project['commentaire']}",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black87),
                          ),
                          // SizedBox(height: 5),
                          // Text(
                          //   "Project Status: ${project['etat']}",
                          //   style:
                          //       TextStyle(fontSize: 20, color: Colors.black87),
                          // ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            // Task info
            FutureBuilder<List<QueryDocumentSnapshot>>(
              future: tasksData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No tasks found'));
                } else {
                  var tasks = snapshot.data!;
                  return Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        var taskData =
                            tasks[index].data() as Map<String, dynamic>;
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            margin: EdgeInsets.only(bottom: 20),
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
                                  "Task: ${taskData['title']}",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 153, 81, 166)),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Email: ${taskData['email']}",
                                  style: TextStyle(fontSize: 13),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Status: ${taskData['etat']}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Description: ${taskData['description']}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "Start Date: ${formatDate(taskData['dateStart'])}",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "End Date: ${formatDate(taskData['dateFin'])}",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
