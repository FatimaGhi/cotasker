import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotasker/core/myappbar.dart';
import 'package:cotasker/core/mybottonnavigationbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String passage = "/MyProject";
bool isChef = true;
String TitlePage = "My project";

class NotiPage extends StatefulWidget {
  const NotiPage({super.key});

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  int selectedindex = 2;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userId;
  bool isChef = false;
  List<DocumentSnapshot> notifications = [];

  Future<void> checkIfChef() async {
    User? user = _auth.currentUser;
    if (user != null) {
      userId = user.uid;
      DocumentSnapshot doc =
          await _firestore.collection('Chef_Project').doc(userId).get();
      if (doc.exists) {
        setState(() {
          isChef = true;
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

  Stream<QuerySnapshot> getNotificationsStream() {
    return FirebaseFirestore.instance
        .collection('Notifications')
        .where('senderId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void handleNotificationAction(
      BuildContext context, String? taskId, String action) async {
    if (taskId == null) return;

    String? projectId;
    String? taskTitle;
    String? taskCreatorId;
    String? reeluser;

    // Fetch the task document
    DocumentSnapshot taskDoc =
        await FirebaseFirestore.instance.collection('Task').doc(taskId).get();
    if (taskDoc.exists) {
      projectId = taskDoc['id_project'];
      taskTitle = taskDoc['title'];
      taskCreatorId = taskDoc['userId'];
      reeluser = taskDoc['id_user_de_task'];
    }

    if (projectId == null || taskTitle == null || taskCreatorId == null) return;

    String notificationTitle;
    String notificationMessage;
    String choixValue;

    if (action == 'accept') {
      DocumentSnapshot projectDoc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .get();
      String? v = projectDoc['title'];
      notificationTitle = 'Task Accepted';
      notificationMessage =
          'The task "$taskTitle" of the project "$v" was approved.';
      choixValue = 'accepted';
    } else {
      DocumentSnapshot projectDoc = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectId)
          .get();
      String? v = projectDoc['title'];
      notificationTitle = 'Task Rejected';
      notificationMessage =
          'The task "$taskTitle" of the project "$v" was rejected.';
      choixValue = 'rejected';
    }

    // Update the task document
    await FirebaseFirestore.instance
        .collection('Task')
        .doc(taskId)
        .update({'choix': choixValue});

    if (reeluser != null) {
      FirebaseFirestore.instance.collection('Notifications').add({
        'userId': reeluser,
        'title': notificationTitle,
        'message': notificationMessage,
        'timestamp': FieldValue.serverTimestamp(),
        'taskId': taskId,
        'projectId': projectId,
        'senderId': taskCreatorId,
      });
    }

    FirebaseFirestore.instance.collection('Notifications').add({
      'userId': reeluser,
      'title': notificationTitle,
      'message': notificationMessage,
      'timestamp': FieldValue.serverTimestamp(),
      'taskId': taskId,
      'projectId': projectId,
      'senderId': taskCreatorId,
    });
  }

  @override
  void initState() {
    super.initState();
    checkIfChef().then((_) {
      getNotificationsStream().listen((snapshot) {
        setState(() {
          notifications = snapshot.docs.where((doc) => doc.exists).toList();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: myappbar("Notification", context),
        bottomNavigationBar: mybottonnavigationbar(selectedindex, (val) {
          setState(() {
            selectedindex = val;
            if (selectedindex == 1) {
              test();
              Navigator.of(context).pushNamed(passage);
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
        body: notifications.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  var notification = notifications[index];
                  var data = notification.data() as Map<String, dynamic>?;

                  return NotificationTile(
                    title: data?['title'] ?? 'No title',
                    message: data?['message'] ?? 'No message',
                    time: (data?['timestamp'] as Timestamp?)
                            ?.toDate()
                            .toString() ??
                        'No time',
                    taskId: data?['taskId'],
                    projectId: data?['projectId'],
                    senderId: data?['senderId'] ?? 'Unknown sender',
                    onAccept: () => handleNotificationAction(
                        context, data?['taskId'], 'accept'),
                    onReject: () => handleNotificationAction(
                        context, data?['taskId'], 'reject'),
                  );
                },
              ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final String? taskId;
  final String? projectId;
  final String senderId;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  NotificationTile({
    required this.title,
    required this.message,
    required this.time,
    this.taskId,
    this.projectId,
    required this.senderId,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    bool showButtons = title != 'Task Accepted' && title != 'Task Rejected';

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(message),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showButtons)
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Accept'),
                  ),
                if (showButtons)
                  ElevatedButton(
                    onPressed: onReject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Reject'),
                  ),
                Expanded(
                  child: Text(
                    time,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
