// import 'package:cotasker/MyFramework/MyAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/BodyApp/InfoProject.dart';
import 'package:cotasker/core/myappbar.dart';
import 'package:cotasker/core/mybottonnavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cotasker/core/myappbar.dart';
// import 'package:cotasker/core/mybottonnavigationbar.dart';
import 'package:flutter/material.dart';

String passage = "/MyProject";
bool isChef = true ;
String TitlePage = "My project";

class MyProject extends StatefulWidget {
  const MyProject({super.key});

  @override
  State<MyProject> createState() => __MyProjectState();
}

class __MyProjectState extends State<MyProject> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; //update now

  // Future<List<Map<String, dynamic>>> _fetchData() async {
  //   QuerySnapshot querySnapshot = await _firestore.collection('projects').get();
  //   if (true) {
  //     return querySnapshot.docs.map((doc) {
  //       return {
  //         "id": doc.id,
  //         "dateStart": doc['dateStart'],
  //         "title": doc['title'],
  //         "commentaire": doc['commentaire']
  //       };
  //     }).toList();
  //   }
  // }
  Future<String?> _fetchUserType() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(user.uid).get();
    return userDoc['type'];
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    QuerySnapshot querySnapshot = await _firestore
        .collection('projects')
        .where('userId', isEqualTo: user.uid)
        .get();

    return querySnapshot.docs.map((doc) {
      return {
        "id": doc.id,
        "dateStart": doc['dateStart'],
        "title": doc['title'],
        "commentaire": doc['commentaire']
      };
    }).toList();
  }
  @override
  void initState() {
    super.initState();
    checkIfChef();
    test();
  }

  Future<void> checkIfChef() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String userId = user.uid;

      DocumentSnapshot doc =
          await _firestore.collection('Chef_Project').doc(userId).get();
      if (doc.exists) {
        setState(() {
          isChef = true;
          TitlePage="My project";
        });
      } else {
        setState(() {
          isChef = false;
          TitlePage = "My Task";
        });
      }
    }
  }

  void test() {
    checkIfChef();
    if (isChef == false) {
      passage = "mytask";
    }
  }

  int selectedindex = 1;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: myappbar("My Project", context),
            bottomNavigationBar: mybottonnavigationbar(1, (val) {
              setState(() {
                selectedindex = val;
                if (selectedindex == 1) {
                  test();
                  Navigator.of(context).pushNamed("$passage");
                } else if (selectedindex == 0) {
                  Navigator.of(context).pushNamed("/HomePage");
                } else if (selectedindex == 3) {
                  Navigator.of(context).pushNamed("/ProfilPage");
                } else if (selectedindex == 2) {
                  Navigator.of(context).pushNamed("/NotiPage");
                }
              });
            },TitlePage),

            //fin navigation bar

            //botton for ADD
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/CreatProject");
              },
              child: Icon(Icons.add),
            ),
            body: FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Creat project '));
                } else {
                  List<Map<String, dynamic>> firstThreeItems = snapshot.data!;

                  return ListView.builder(
                    itemCount: firstThreeItems.length,
                    itemBuilder: (context, index) {
                      String dateStart =
                          firstThreeItems[index]['dateStart'] ?? '';
                      String commentaire =
                          firstThreeItems[index]['commentaire'] ?? '';
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
                                subtitle: Text("$commentaire"),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Colors.grey.shade400),
                                  onPressed: () {
                                    // Implement your edit functionality here
                                    print(
                                        "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");

                                    // Navigator.pushNamed(context, "/Info_project");
                                    String projectId =
                                        firstThreeItems[index]['id'];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InfoProject(
                                                idProject: projectId,
                                              )),
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

//   List<QueryDocumentSnapshot> data = [];

//   getData() async {
//     QuerySnapshot querySnapshot =
//         await FirebaseFirestore.instance.collection("projects").get();
        
//     data.addAll(querySnapshot.docs);
    

//     setState(() {});
//   }

//   @override
//   void initState() {
//     getData();
//     super.initState();
//   }

//   int selectedindex = 1;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//             appBar: myappbar("My Project", context),
//             bottomNavigationBar: mybottonnavigationbar(1, (val) {
//               setState(() {
//                 selectedindex = val;
//                 if (selectedindex == 1) {
//                   Navigator.of(context).pushNamed("MyProject");
//                 }
//                 if (selectedindex == 0) {
//                   Navigator.of(context).pushNamed("HomePage");
//                 }
//                 if (selectedindex == 3) {
//                   Navigator.of(context).pushNamed("ProfilPage");
//                 }
//                 if (selectedindex == 2) {
//                   Navigator.of(context).pushNamed("NotiPage");
//                 }
//               });
//             }),

//             //fin navigation bar

//             //botton for ADD
//             floatingActionButton: FloatingActionButton(
//               onPressed: () {
//                 Navigator.of(context).pushNamed("CreatProject");
//               },
//               child: Icon(Icons.add),
//             ),
//             // body: Container(
//             //     margin: EdgeInsets.only(
//             //       right: 15,
//             //       left: 15,
//             //       top: 20,
//             //     ),
//             //     child: ListView(
//             //       children: [
//             //         Container(
//             //           margin: EdgeInsets.only(bottom: 10),
//             //           decoration: BoxDecoration(
//             //             color: Colors.white,
//             //             border: Border.all(
//             //               color: Color.fromARGB(255, 141, 101, 186),
//             //               width: 2.0,
//             //             ),
//             //             borderRadius: BorderRadius.circular(10.0),
//             //           ),
//             //           child: ListTile(
//             //               onTap: () =>
//             //                   {Navigator.of(context).pushNamed("Info_project")},
//             //               leading: Text("xx/xx/xxx"),
//             //               title: Text(
//             //                 "Name Project 1 ",
//             //                 style:
//             //                     TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             //               ),
//             //               subtitle: Text(
//             //                 "Destripistion",
//             //               )),
//             //         ),
//             //       ],
//             //     )),

//             body: GridView.builder(
//               itemCount: data.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 1,
//                 mainAxisExtent: 110,
//               ),
//               itemBuilder: (context, i) {
//                 return Card(
//                   child: SingleChildScrollView(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(
//                           color: Color.fromARGB(255, 141, 101, 186),
//                           width: 2.0,
//                         ),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       padding: EdgeInsets.all(10),
//                       child: Column(
//                         // margin: EdgeInsets.only(bottom: 10),

//                         children: [
//                           ListTile(

//                               // onTap: () =>
//                               // {Navigator.of(context).pushNamed("Info_project")},
//                               leading: Text("xx/xx/xxx"),
//                               title: Text(
//                                 "${data[i]['title']} ",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Text(
//                                 "${data[i]['commentaire']} ",
//                               )),
//                           // Text("${data[i]['title']}  : ${data[i]['dateStart']}")
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               // ),
//             )));
//   }
// }
//************************************************************************** */

