// import 'dart:ui';

class Taska {
  String? id;
  String? userId;
  String title;
  DateTime dateStart;
  DateTime dateFin;
  String etat;
  String email;
  String description;
 String  id_project;
 String id_user_de_task;
 String choix;

  Taska({
    this.id,
    required this.userId,
    required this.title,
    required this.dateStart,
    required this.dateFin,
    required this.etat,
    required this.email,
    required this.description,
    required this.id_project,
    required this.id_user_de_task,
    required this.choix,
  });

  // Convert a Task object to a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'dateStart': dateStart.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'etat': etat,
      'email': email,
      'description': description,
      'id_project': id_project,
      'id_user_de_task': id_user_de_task,
      'choix':choix,
    };
  }

  // Create a Task object from a Map object
  factory Taska.fromMap(Map<String, dynamic> map) {
    return Taska(
      id: map['id'] ,
      userId: map['userId'],
      title: map['title'],
      dateStart: DateTime.parse(map['dateStart']?? DateTime.now().toIso8601String()),
      dateFin:   DateTime.parse(map['dateFin']?? DateTime.now().toIso8601String()),
      etat: map['etat'],
      email: map['email'],
      description: map['description'],
      id_project:map['id_project'],
      id_user_de_task:map['id_user_de_task'],
      choix:map['choix'],
    );
  }
}
