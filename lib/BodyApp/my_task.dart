import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/BodyApp/InfoTask.dart';
import 'package:cotasker/core/myappbar.dart';
import 'package:cotasker/core/mybottonnavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String passage = "/MyProject";
bool isChef = true;
String TitlePage = "My project";

class my_task extends StatefulWidget {
  const my_task({super.key});

  @override
  State<my_task> createState() => _my_taskState();
}

class _my_taskState extends State<my_task> {
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;
      QuerySnapshot querySnapshot = await _firestore
          .collection('Task')
          .where('id_user_de_task', isEqualTo: userId)
          .get();

      return querySnapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "dateStart": doc['dateStart'],
          "title": doc['title'],
          "description": doc['description']
        };
      }).toList();
    } else {
      return [];
    }
  }

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> checkIfChef() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;

      DocumentSnapshot doc =
          await _firestore.collection('Chef_Project').doc(userId).get();
      if (doc.exists) {
        setState(() {
          isChef = true;
          TitlePage = "My project";
        });
      } else {
        setState(() {
          isChef = false;
          TitlePage = "My Task";
        });
      }
    }
  }

  int selectedindex = 1;
  // String passage = "/MyProject";
  void test() {
    checkIfChef();
    if (isChef == false) {
      passage = "mytask";
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfChef();
    test();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: myappbar("My Task", context),
            bottomNavigationBar: mybottonnavigationbar(1, (val) {
              setState(() {
                selectedindex = val;
                test();
                if (selectedindex == 1) {
                  Navigator.of(context).pushNamed("$passage");
                }
                if (selectedindex == 0) {
                  Navigator.of(context).pushNamed("/HomePage");
                }
                if (selectedindex == 3) {
                  Navigator.of(context).pushNamed("/ProfilPage");
                }
                if (selectedindex == 2) {
                  Navigator.of(context).pushNamed("/NotiPage");
                }
              });
            }, TitlePage),
            // b
            body: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('You dont have any task'));
                } else {
                  List<Map<String, dynamic>> firstThreeItems = snapshot.data!;

                  return ListView.builder(
                    itemCount: firstThreeItems.length,
                    itemBuilder: (context, index) {
                      String dateStart =
                          firstThreeItems[index]['dateStart'] ?? '';
                      String description =
                          firstThreeItems[index]['description'] ?? '';
                      String title = firstThreeItems[index]['title'] ?? '';

                      List<String> dateParts = dateStart.split('T');
                      String date = dateParts[0];
                      String time = dateParts.length > 1 ? dateParts[1] : '';

                      List<String> dateElements =
                          date.split('-'); // Split date into year, month, day
                      List<String> timeElements = time.split(
                          ':'); // Split time into hour, minute, second, millisecond

                      return ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text('Year: ${dateElements[0]}'),
                            // Text('Month: ${dateElements[1]}'),
                            // Text('Day: ${dateElements[2]}'),
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color.fromARGB(255, 141, 101, 186),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: ListTile(
                                leading: Text(
                                    "${dateElements[2]}/${dateElements[1]}/${dateElements[0]}"),
                                onTap: () => {
                                  // print(
                                  //     "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO"),
                                  // Navigator.of(context)
                                  //     .pushReplacementNamed("/ProfilPage")
                                },
                                title: Text(
                                  "$title",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text("${description}"),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Colors.grey.shade400),
                                  onPressed: () {
                                    // Implement your edit functionality here
                                    print(
                                        "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");

                                    // // Navigator.pushNamed(context, "/Info_project");
                                    String taskId =
                                        firstThreeItems[index]['id'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InfoTask(taskId: taskId)),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            )));
  }
}
