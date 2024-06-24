// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class InfoProject extends StatefulWidget {
  const InfoProject({super.key});

  @override
  State<InfoProject> createState() => _InfoProjectState();
}

class _InfoProjectState extends State<InfoProject> {
  // List<QueryDocumentSnapshot> data = [];
  // getData() async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection("projects").get();
  //   data.addAll(querySnapshot.docs);
  // @override
  // void setState() {

  // }
  // }

  // @override
  // void initState() {
  //   // getData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Container(
        child: Text("fatima"),
      )
          // body: GridView.builder(
          //   itemCount: data.length,
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //   ),
          //   itemBuilder: (context, i) {
          //     return Card(
          //       child: Container(
          //         padding: EdgeInsets.all(10),
          //         child: Column(
          //           children: [Text("${data[i]['title']}")],
          //         ),
          //       ),
          //     );
          //   },
          // ),
          ),
    );
  }
}
