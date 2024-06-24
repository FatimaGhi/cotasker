import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/BodyApp/creat_Task.dart';
import 'package:cotasker/MyFramework/buttonForm.dart';
import 'package:cotasker/MyFramework/textFieldForm.dart';
import 'package:cotasker/core/myappbar.dart';
import 'package:cotasker/model/project_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreatProject extends StatefulWidget {
  static const routeName = 'create-project';

  const CreatProject({super.key});

  @override
  State<CreatProject> createState() => _MyprojectState();
}

class _MyprojectState extends State<CreatProject> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController N_Project = TextEditingController();
  TextEditingController N_task = TextEditingController();
  TextEditingController Commentaire = TextEditingController();

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

// getuser
  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  CollectionReference projects =
      FirebaseFirestore.instance.collection('projects');

  Future<void> addProject(Project project) async {
    // CollectionReference projects =
    //     FirebaseFirestore.instance.collection('projects');

    return projects
        .doc(project.id)
        .set(project.toMap())
        .then((value) => print("Project Added"))
        .catchError((error) => print("Failed to add project: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: myappbar("Creat Project ", context),
            body: SingleChildScrollView(
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 100, bottom: 20),
                // alignment: Alignment.center,
                // child: Container(
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      formInput(
                          mylable: "Name Project", mycontroller: N_Project),
                      Container(
                        height: 40,
                      ),
                      TextFormField(
                        controller: _dateController1,
                        decoration: InputDecoration(
                            labelText: 'Date start',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey))),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(new FocusNode());
                          await _selectDate(context, _dateController1);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select start date';
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
                        height: 40,
                      ),
                      formInput(
                        mylable: "Number Task",
                        mycontroller: N_task,
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                      Container(
                        height: 40,
                      ),
                      formInput(
                          mylable: "Commentaire", mycontroller: Commentaire),
                      Container(
                        height: 70,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: MyButtonT(
                            title: "Next",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                String? userId = getCurrentUserId();
                                if (userId != null) {
                                  Project project = Project(
                                    userId: userId,
                                    title: N_Project.text,
                                    dateStart:
                                        DateTime.parse(_dateController1.text),
                                    dateEnd:
                                        DateTime.parse(_dateController2.text),
                                    etat: "consute",
                                    commentaire: Commentaire.text,
                                    nTask: int.parse(N_task.text),
                                  );

                                  addProject(project);
                                  // print(projects.doc(widget.docid));
                                }
                                Navigator.of(context).pushNamed(Creat_task.routeName);
                                // },
                              }
                            }),
                      )
                    ])))));
  }
}
