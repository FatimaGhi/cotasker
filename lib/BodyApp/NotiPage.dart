import 'package:cotasker/core/myappbar.dart';
import 'package:cotasker/core/mybottonnavigationbar.dart';
import 'package:flutter/material.dart';

class NotiPage extends StatefulWidget {
  const NotiPage({super.key});

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage>{
 int selectedindex = 2;   

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: myappbar("Notification ", context),
      bottomNavigationBar: mybottonnavigationbar(2, (val) {
        setState(() {
          selectedindex = val;
          if (selectedindex == 1) {
            Navigator.of(context).pushNamed("MyProject");
          }
          if (selectedindex == 0) {
            Navigator.of(context).pushNamed("HomePage");
          }
          if (selectedindex == 3) {
            Navigator.of(context).pushNamed("ProfilPage");
          }
          if (selectedindex == 2) {
            Navigator.of(context).pushNamed("NotiPage");
          }
        });
      }),
    ));
  }
}