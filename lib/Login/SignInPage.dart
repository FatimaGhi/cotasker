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
  // get errorMessage => null;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: isloading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.only(top: 130, right: 20, left: 20),

                    // alignment: Alignment.center,
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
                        //input
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
                                //text forget password
                                InkWell(
                                    onTap: () async {
                                      if (!email.text.isEmpty) {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                                email: email.text);
                                        //$$$$$$$$$$$$$$ khasni dak dialog
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text("Forget password ?"),
                                    )),

                                //botton lodin
                                Container(
                                  width: 200,
                                  margin: EdgeInsets.only(top: 50),
                                  child: MyButtonT(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          try {
                                            isloading = true;
                                            setState(() {});
                                            final credential =
                                                await FirebaseAuth
                                                    .instance
                                                    .signInWithEmailAndPassword(
                                                        email: email.text,
                                                        password:
                                                            password.text);
                                            isloading = false;
                                            setState(() {});
                                            if (credential
                                                .user!.emailVerified) {
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      "HomePage");
                                            } else {
                                              // FirebaseAuth.instance.currentUser!
                                              //     .sendEmailVerification();
                                              print(
                                                  " han khasni n3ml dak dialogi bax yrj2 le barid deyalo ");
                                            }
                                          } on FirebaseAuthException catch (e) {
                                            isloading = false;
                                            setState(() {});
                                            if (e.code == 'user-not-found') {
                                              print(
                                                  'No user found for that email.');
                                              // AwesomeDialog(
                                              //   context: context,
                                              //   dialogType: DialogType.info,
                                              //   animType: AnimType.rightSlide,
                                              //   title: 'Dialog Title',
                                              //   desc: 'No user found for that email',
                                              // ).show();
                                            } else if (e.code ==
                                                'wrong-password') {
                                              print(
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
                        // margin: EdgeInsets.only(top: 60),
                        InkWell(
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacementNamed("creatAccount");
                          },
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(text: ("Dont't have an account?  ")),
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
