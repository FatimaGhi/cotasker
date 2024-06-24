import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/core/myappbar.dart';
import 'package:cotasker/core/mybottonnavigationbar.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("projects").get();
    data.addAll(querySnapshot.docs);

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  int selectedindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar("Home", context),
      // bottomNavigationBar: mybottonnavigationbar(0, (val) {
      //   setState(() {
      //     selectedindex = val;
      //     if (selectedindex == 1) {
      //       Navigator.of(context).pushNamed("MyProject");
      //     }
      //     if (selectedindex == 0) {
      //       Navigator.of(context).pushNamed("HomePage");
      //     }
      //     if (selectedindex == 3) {
      //       Navigator.of(context).pushNamed("ProfilPage");
      //     }
      //     if (selectedindex == 2) {
      //       Navigator.of(context).pushNamed("NotiPage");
      //     }
      //   });
      // }),
      // body: ListView(
      //   children: [Text("Hello in application ")],
      // ),
      body: GridView.builder(
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 80,
        ),
        itemBuilder: (context, i) {
          return Card(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text("${data[i]['title']}  : ${data[i]['dateStart']}")
                ],
              ),
            ),
          );
        },
        // ),
      ),
    );
  }
}
