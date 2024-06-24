import 'package:flutter/material.dart';

import '../core/myappbar.dart';

class DetailTaskScreen extends StatelessWidget {
  static const routeName = 'detail-task-screen';
  const DetailTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myappbar("project detail", context),
      body: Center(
        child: Text('center text'),
      ),
    );
  }
}
