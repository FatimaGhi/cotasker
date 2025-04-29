import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/BodyApp/InfoProject.dart';
import 'package:cotasker/MyFramework/textFieldForm.dart';
// import 'package:cotasker/core/myappbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cotasker/model/Task_model.dart';

int i = 1;

class Creat_task extends StatefulWidget {
  final String task_project;
  const Creat_task({super.key, required this.task_project});

  @override
  State<Creat_task> createState() => __Creat_taskState();
}

class __Creat_taskState extends State<Creat_task> {
  //****************** */
  int nTask = 2;
  //****************** */
  //*************** text for me ***************
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("project").get();
    data.addAll(querySnapshot.docs);

    setState(() {});
  }
  // *************** fin text for me ***************

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController N_task = TextEditingController();

  TextEditingController Email = TextEditingController();
  TextEditingController Descrpstion = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  String textButton = "go to My project";
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  // chek user de exicute task
  Future<String?> getUserIdByEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    }
    return null;
  }

  Future<String?> getProjectNameById(String projectId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('project')
        .doc(projectId)
        .get();
    if (doc.exists) {
      return doc['name'];
    }
    return null;
  }

  Future<String?> getUserNameById(String userId) async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (doc.exists) {
      return doc['name'];
    }
    return null;
  }

  // fin
  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Error",
            style: TextStyle(color: const Color.fromARGB(255, 81, 6, 94)),
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 18),
          ),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Future<void> addTask(Taska task) async {
  //   CollectionReference Tasks = FirebaseFirestore.instance.collection('Task');

  //   return Tasks.doc(task.id)
  //       .set(task.toMap())
  //       .then((value) => print(
  //           "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55 Task Added"))
  //       .catchError((error) => print(
  //           " %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55Failed to add task: $error"));
  // }
  // Future<void> addTask(Taska task, String chefProjectId) async {
  //   CollectionReference tasks = FirebaseFirestore.instance.collection('Task');
  //   String? userId = getCurrentUserId();
  //   if (userId == null) {
  //     showErrorDialog(context, "User not logged in");
  //     return;
  //   }
  //   String taskId = tasks.doc().id;
  //   task.id = taskId;

  //   print(
  //       "Adding Task: ${task.id}, ${task.id_user_de_task}, ${task.description}");

  //   if (task.id == null ||
  //       task.id_user_de_task == null ||
  //       task.description == null) {
  //     showErrorDialog(context, "Task data contains null values");
  //     return;
  //   }

  //   try {
  //     await tasks.doc(task.id).set(task.toMap());
  //     print(
  //         "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN Task Added");

  //     // Send Notification
  //     sendNotification(
  //       userId,
  //       'New Task Assigned',
  //       'Hey 👋 ${task.id_user_de_task}, you were added to a project "${task.id_project}" and you have got a task. Here is the description: ${task.description}. Will you take the task?',
  //       task.id!,
  //       chefProjectId,
  //       task.id_user_de_task,
  //     );
  //   } catch (error) {
  //     print(
  //         "NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN Failed to add task: $error");
  //   }
  // }

  // void sendNotification(String userId, String title, String message,
  //     String taskId, String projectId, String senderId) {
  //   try {
  //     FirebaseFirestore.instance.collection('Notifications').add({
  //       'userId': userId,
  //       'title': title,
  //       'message': message,
  //       'timestamp': FieldValue.serverTimestamp(),
  //       'taskId': taskId,
  //       'projectId': projectId,
  //       'senderId': senderId,
  //     });
  //     print("MMMMMMMMMMMMMMMMMMMMMMMMMMMMM Notification sent to Firestore");
  //   } catch (error) {
  //     print(
  //         " MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMFailed to send notification: $error");
  //   }
  // }
  Future<void> addTask(Taska task, String chefProjectId) async {
    CollectionReference tasks = FirebaseFirestore.instance.collection('Task');
    try {
      // Create a new document reference with an auto-generated ID
      DocumentReference taskDocRef = tasks.doc();
      task.id = taskDocRef.id;

      // Set the task data in the Firestore collection
      await taskDocRef.set(task.toMap());

      // Get user's ID to send notification
      String? userId = await getUserIdByEmail(task.email);
      if (userId != null) {
        // Send notification to user
        sendNotification(
          userId,
          'New Task Assigned',
          'Hey 👋 ${task.email}, you were added to a project and you have got a task "${task.title}". Will you take the task?',
          task.id!,
          chefProjectId,
          task.id_user_de_task,
        );
      }
      print("Task Added");
    } catch (error) {
      print("Failed to add task: $error");
    }
  }

  void sendNotification(String userId, String title, String message,
      String taskId, String projectId, String senderId) {
    FirebaseFirestore.instance.collection('Notifications').add({
      'userId': userId,
      'title': title,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'taskId': taskId,
      'projectId': projectId,
      'senderId': senderId,
    });
  }

  @override
  void initState() {
    print(
        "--------------------------hadi dyal initState ---------------------------------$i-- ");
    if (i < 3) textButton = " go to task ${i + 1}";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: myappbar("Creat Task", context),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(right: 20, left: 20, top: 60, bottom: 20),
          child: Form(
            key: _formKey,
            child: Column(children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "create task",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 120, 20, 138)),
                ),
              ),
              formInput(mylable: "Name Task ", mycontroller: N_task),
              Container(
                height: 40,
              ),
              formInput(mylable: "Email User ", mycontroller: Email,keyboardType: TextInputType.emailAddress,),
              Container(
                height: 40,
              ),
              formInput(mylable: "Description ", mycontroller: Descrpstion),
              Container(
                height: 40,
              ),
              TextFormField(
                controller: _dateController1,
                decoration: InputDecoration(
                    labelText: 'Start date',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey))),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _selectDate(context, _dateController1);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select  Start date';
                  }
                  return null;
                },
              ),
              Container(
                height: 40,
              ),
              TextFormField(
                controller: _dateController2,
                decoration: InputDecoration(
                    labelText: 'Date End',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey))),
                onTap: () async {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  await _selectDate(context, _dateController2);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select  end date';
                  }
                  return null;
                },
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: MaterialButton(
                  color: Color.fromARGB(255, 141, 101, 186),
                  height: 54,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () async {
                    // if (i <= 3) {
                    print(
                        "******************************************************************************************$i");
// add fe base de doonee
                    if (_formKey.currentState!.validate()) {
                      String? userId = getCurrentUserId();
                      String? id_user_de_task =
                          await getUserIdByEmail(Email.text);
                      print("${id_user_de_task}");
                      if (userId != null && id_user_de_task != null) {
                        Taska task = Taska(
                          userId: userId,
                          title: N_task.text,
                          dateStart: DateTime.parse(_dateController1.text),
                          dateFin: DateTime.parse(_dateController2.text),
                          etat: 'pending',
                          email: Email.text,
                          description: Descrpstion.text,
                          id_project: widget.task_project,
                          id_user_de_task: id_user_de_task,
                          choix: "",
                        );

                        await addTask(task, widget.task_project);
                        // Navigator.of(context).pop();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => InfoProject(
                                      idProject: widget.task_project,
                                    )));
                      } else {
                        showErrorDialog(context,
                            "User with email ${Email.text} not found ");
                      }
                    }
                  },
                  child: Text(
                    "add task ",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 238, 236, 240),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
