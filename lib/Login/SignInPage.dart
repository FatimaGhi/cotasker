import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                alignment: Alignment.center,
                child: Text("login ",
                    style: TextStyle(
                        fontSize: 40,
                        color: Color.fromARGB(255, 222, 10, 10))))));
  }
}
