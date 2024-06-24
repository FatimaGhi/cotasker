import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/BodyApp/CreatProject.dart';
import 'package:cotasker/BodyApp/HomePage.dart';
import 'package:cotasker/BodyApp/detail_task_screen.dart';
import 'package:cotasker/BodyApp/notification_screen.dart';
import 'package:cotasker/BodyApp/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/myappbar.dart';
import '../core/mybottonnavigationbar.dart';

class MyProject extends StatefulWidget {
  static const routeName = 'my-project';
  const MyProject({super.key});

  @override
  State<MyProject> createState() => _MyProjectState();
}

class _MyProjectState extends State<MyProject> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _selectedIndex = 1;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    ProjectPage(),
    NotificationScreen(),
    Profil_page(),
  ];

  Future<List<Map<String, dynamic>>> _fetchData() async {
    QuerySnapshot querySnapshot = await _firestore.collection('projects').get();
    return querySnapshot.docs.map((doc) {
      return {
        "dateStart": doc['dateStart'],
        "title": doc['title'],
        "commentaire": doc['commentaire']
      };
    }).toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: myappbar("My Project", context),
        bottomNavigationBar:
            mybottonnavigationbar(_selectedIndex, _onItemTapped),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(CreatProject.routeName);
          },
          child: Icon(Icons.add),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}

// class ProjectPage extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Map<String, dynamic>>> _fetchData() async {
//     QuerySnapshot querySnapshot = await _firestore.collection('projects').get();
//     return querySnapshot.docs.map((doc) {
//       return {
//         "dateStart": doc['dateStart'],
//         "title": doc['title'],
//         "commentaire": doc['commentaire']
//       };
//     }).toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: myappbar("Project", context),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('Create project'));
//           } else {
//             List<Map<String, dynamic>> firstThreeItems = snapshot.data!;

//             return ListView.builder(
//               itemCount: firstThreeItems.length,
//               itemBuilder: (context, index) {
//                 String dateStart = firstThreeItems[index]['dateStart'] ?? '';
//                 String commentaire =
//                     firstThreeItems[index]['commentaire'] ?? '';
//                 String title = firstThreeItems[index]['title'] ?? '';

//                 List<String> dateParts = dateStart.split('T');
//                 String date = dateParts[0];
//                 String time = dateParts.length > 1 ? dateParts[1] : '';

//                 List<String> dateElements = date.split('-');
//                 List<String> timeElements = time.split(':');

//                 return ListTile(
//                   title: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           margin: EdgeInsets.only(bottom: 10),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(
//                               color: Color.fromARGB(255, 141, 101, 186),
//                               width: 2.0,
//                             ),
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                           child: ListTile(
//                             leading: Text(
//                                 "${dateElements[2]}/${dateElements[1]}/${dateElements[0]}"),
//                             onTap: () {},
//                             title: Text(
//                               "$title",
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             subtitle: Text("$commentaire"),
//                             trailing: IconButton(
//                               icon:
//                                   Icon(Icons.edit, color: Colors.grey.shade400),
//                               onPressed: () {
//                                 Navigator.pushNamed(
//                                     context, DetailTaskScreen.routeName);
//                               },
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

class ProjectPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchData() async {
    QuerySnapshot querySnapshot = await _firestore.collection('projects').get();
    return querySnapshot.docs.map((doc) {
      return {
        "dateStart": doc['dateStart'],
        "title": doc['title'],
        "commentaire": doc['commentaire']
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case '/':
            builder =
                (BuildContext context) => ProjectList(fetchData: _fetchData);
            break;
          case DetailTaskScreen.routeName:
            builder = (BuildContext context) => const DetailTaskScreen();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );
  }
}

class ProjectList extends StatelessWidget {
  final Future<List<Map<String, dynamic>>> Function() fetchData;

  ProjectList({required this.fetchData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar("Project", context),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Create project'));
          } else {
            List<Map<String, dynamic>> firstThreeItems = snapshot.data!;

            return ListView.builder(
              itemCount: firstThreeItems.length,
              itemBuilder: (context, index) {
                String dateStart = firstThreeItems[index]['dateStart'] ?? '';
                String commentaire =
                    firstThreeItems[index]['commentaire'] ?? '';
                String title = firstThreeItems[index]['title'] ?? '';

                List<String> dateParts = dateStart.split('T');
                String date = dateParts[0];
                String time = dateParts.length > 1 ? dateParts[1] : '';

                List<String> dateElements = date.split('-');
                List<String> timeElements = time.split(':');

                return ListTile(
                  title: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                            onTap: () {},
                            title: Text(
                              "$title",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("$commentaire"),
                            trailing: IconButton(
                              icon:
                                  Icon(Icons.edit, color: Colors.grey.shade400),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, DetailTaskScreen.routeName);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
