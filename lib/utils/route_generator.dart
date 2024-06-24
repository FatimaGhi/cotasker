import 'package:cotasker/BodyApp/detail_task_screen.dart';
import 'package:flutter/material.dart';
import '../BodyApp/MyProject.dart';
import '../BodyApp/creat_Task.dart';
import '../Login/CreateAccoint.dart';

String initialRoute = MyProject.routeName;

class RoutGenerator {
  static Route<dynamic> generateRout(RouteSettings settings) {
    switch (settings.name) {
      case MyProject.routeName:
        return MaterialPageRoute(builder: (_) => MyProject());
      case CreatAccountPage.routeName:
        return MaterialPageRoute(builder: (_) => CreatAccountPage());
      case DetailTaskScreen.routeName:
        return MaterialPageRoute(builder: (_) => DetailTaskScreen());
      case Creat_task.routeName:
        return MaterialPageRoute(builder: (_) => Creat_task());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('ErrorRoute'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute(this.widget)
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return new SlideTransition(
              position: new Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
