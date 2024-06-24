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

  Taska({
    this.id,
    required this.userId,
    required this.title,
    required this.dateStart,
    required this.dateFin,
    required this.etat,
    required this.email,
    required this.description,
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
    );
  }
}
