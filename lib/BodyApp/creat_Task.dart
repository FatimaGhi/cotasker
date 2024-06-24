import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/MyFramework/textFieldForm.dart';
// import 'package:cotasker/core/myappbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cotasker/model/Task_model.dart';

int i = 1;

class Creat_task extends StatefulWidget {
  const Creat_task({super.key});

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

  Future<void> addTask(Taska task) async {
    CollectionReference Tasks = FirebaseFirestore.instance.collection('Task');

    return Tasks.doc(task.id)
        .set(task.toMap())
        .then((value) => print(
            "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55 Task Added"))
        .catchError((error) => print(
            " %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55Failed to add task: $error"));
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
              padding:
                  EdgeInsets.only(right: 20, left: 20, top: 60, bottom: 20),
              child: Form(
                  key: _formKey,
                  child: Column(children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Task  ${i} ",
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
                    formInput(mylable: "Email User ", mycontroller: Email),
                    Container(
                      height: 40,
                    ),
                    formInput(
                        mylable: "Description ", mycontroller: Descrpstion),
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
                        onPressed: () {
                          if (i <= 3) {
                            print(
                                "******************************************************************************************$i");
// add fe base de doonee
                            if (_formKey.currentState!.validate()) {
                              String? userId = getCurrentUserId();
                              if (userId != null) {
                                Taska task = Taska(
                                  userId: userId,
                                  title: N_task.text,
                                  dateStart:
                                      DateTime.parse(_dateController1.text),
                                  dateFin:
                                      DateTime.parse(_dateController2.text),
                                  etat: 'pending',
                                  email: Email.text,
                                  description: Descrpstion.text,
                                );

                                addTask(task);
                              }
                            }
                            i += 1;
                            print(
                                "****************************************************************************men ba3ed incrementation **************$i");

                            Navigator.of(context).pushNamed("Creat_task");
                          }
                          if (i == 3 + 1) {
                            setState(() {
                              i = 1;
                            });
                            Navigator.of(context)
                                .pushReplacementNamed("HomePage");
                          }
                        },
                        child: Text(
                          "$textButton",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 238, 236, 240),
                          ),
                        ),
                      ),
                    )
                  ])))),
    );
  }
}
