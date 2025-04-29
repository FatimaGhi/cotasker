import 'package:cotasker/MyFramework/textFieldForm.dart';
import 'package:cotasker/MyFramework/buttonForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:awesome_dialog/awesome_dialog.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isLoading = false;

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
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.only(top: 130, right: 20, left: 20),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 45, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Please sign in to continue.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Container(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                formInput(
                                    mylable: "email",
                                    mycontroller: email,
                                    keyboardType: TextInputType.emailAddress),
                                Container(
                                  height: 30,
                                ),
                                formInput(
                                    mylable: "Password",
                                    mycontroller: password,
                                    keyboardType:
                                        TextInputType.visiblePassword),
                                InkWell(
                                    onTap: () async {
                                      if (!email.text.isEmpty) {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: email.text);
                                        showAlertDialog(
                                            context,
                                            "Password Reset",
                                            "A password reset link has been sent to your email.");
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text("Forget password ?"),
                                    )),
                                Container(
                                  width: 200,
                                  margin: EdgeInsets.only(top: 50),
                                  child: MyButtonT(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          try {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            final credential =
                                                await FirebaseAuth
                                                    .instance
                                                    .signInWithEmailAndPassword(
                                                        email: email.text,
                                                        password:
                                                            password.text);
                                            setState(() {
                                              isLoading = false;
                                            });
                                            if (credential
                                                .user!.emailVerified) {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      "/HomePage");
                                            } else {
                                              showAlertDialog(
                                                  context,
                                                  "Email Verification",
                                                  "Please verify your email before logging in. A verification link has been sent to your email.");
                                              await FirebaseAuth
                                                  .instance.currentUser!
                                                  .sendEmailVerification();
                                            }
                                          } on FirebaseAuthException catch (e) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            if (e.code == 'user-not-found') {
                                              showAlertDialog(context, "Error",
                                                  'No user found for that email.');
                                            } else if (e.code ==
                                                'wrong-password') {
                                              showAlertDialog(context, "Error",
                                                  'Wrong password provided for that user.');
                                            }
                                          }
                                        }
                                      },
                                      title: "Login"),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed("/creatAccount");
                          },
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(text: ("Don't have an account?  ")),
                              TextSpan(
                                  text: "  Register",
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 68, 2, 80),
                                      fontWeight: FontWeight.bold)),
                            ]),
                          ),
                        )
                      ],
                    ),
                  )));
  }
}
