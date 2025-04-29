import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/MyFramework/buttonForm.dart';
import 'package:cotasker/MyFramework/textFieldForm.dart';
import 'package:cotasker/model/User_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

class CreatAccountPage extends StatefulWidget {
  const CreatAccountPage({super.key});
  @override
  State<CreatAccountPage> createState() => _CreatAccountPageState();
}

class _CreatAccountPageState extends State<CreatAccountPage> {
  TextEditingController frist_name = TextEditingController();
  TextEditingController las_name = TextEditingController();
  TextEditingController numbe = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController passwod = TextEditingController();

  String? getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<void> addUser(Users user) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return users
        .doc(user.id)
        .set(user.toMap())
        .then((value) =>
            print("**************************************cusers  Added"))
        .catchError((error) =>
            print("****************************Failed to add users : $error"));
  }

  Future<void> addchef_project(Users chef_Project) async {
    CollectionReference Chef_Project =
        FirebaseFirestore.instance.collection('Chef_Project');

    return Chef_Project.doc(chef_Project.id)
        .set(chef_Project.toMap())
        .then((value) =>
            print("***************************************chef project  Added"))
        .catchError((error) => print(
            "****************************Failed to add chef project : $error"));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _selectedOption = 'User'; // for redio button

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: SingleChildScrollView(
                padding:
                    EdgeInsets.only(right: 20, left: 20, top: 80, bottom: 20),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(bottom: 35),
                          child: Text("Creat Account",
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 141, 101, 186))),
                        ),
                        formInput(
                            mylable: "First Name", mycontroller: frist_name),
                        Container(
                          height: 20,
                        ),
                        formInput(mylable: "Last Name", mycontroller: las_name),
                        Container(
                          height: 20,
                        ),
                        formInput(
                          mylable: "Email",
                          mycontroller: email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        Container(
                          height: 20,
                        ),
                        formInput(
                          mylable: "Number",
                          mycontroller: numbe,
                          keyboardType: TextInputType.phone,
                        ),
                        Container(
                          height: 20,
                        ),
                        formInput(
                          mylable: "Password",
                          mycontroller: passwod,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        Container(
                          height: 40,
                        ),
                        RadioListTile<String>(
                          title: Text('User'),
                          value: 'User',
                          groupValue: _selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: Text('Chef Project'),
                          value: 'Chef_Project',
                          groupValue: _selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                        MyButtonT(
                            title: "Next",
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: email.text,
                                    password: passwod.text,
                                  );
                                  FirebaseAuth.instance.currentUser!
                                      .sendEmailVerification();

                                  String? userId = getCurrentUserId();
                                  if (userId != null) {
                                    Users users = Users(
                                      id: userId,
                                      firstName: frist_name.text,
                                      lastName: las_name.text,
                                      N_tel: numbe.text,
                                      email: email.text,
                                      password: passwod.text,
                                      type: _selectedOption,
                                    );

                                    if (_selectedOption == "User") {
                                      addUser(users);
                                    } else {
                                      addchef_project(users);
                                    }
                                  }

                                  showAlertDialog(context, "Success",
                                      "Account created successfully. Please check your email for verification.");
                                  Navigator.of(context)
                                      .pushReplacementNamed("/signin");
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    showAlertDialog(context, "Error",
                                        "The password provided is too weak.");
                                  } else if (e.code ==
                                      'email-already-in-use') {
                                    showAlertDialog(context, "Error",
                                        "The account already exists for that email.");
                                  }
                                } catch (e) {
                                  showAlertDialog(context, "Error",
                                      "An unexpected error occurred.");
                                }
                              }
                            }),
                        Container(
                          height: 50,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed("/signin");
                          },
                          child: Text.rich(TextSpan(children: [
                            TextSpan(text: ("Already have an account??  ")),
                            TextSpan(
                                text: "  Sign in",
                                style: TextStyle(
                                    color: const Color.fromARGB(255, 68, 2, 80),
                                    fontWeight: FontWeight.bold)),
                          ])),
                        )
                      ],
                    )))));
  }
}
