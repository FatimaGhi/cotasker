import 'package:flutter/material.dart';

class CreatAccountPage extends StatefulWidget {
  const CreatAccountPage({super.key});
  @override
  State<CreatAccountPage> createState() => _CreatAccountPageState();
}

class _CreatAccountPageState extends State<CreatAccountPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
                alignment: Alignment.center,
                child: Text("CreatAccountPage ",
                    style: TextStyle(
                        fontSize: 40,
                        color: Color.fromARGB(255, 222, 10, 10))))));
  }
}
