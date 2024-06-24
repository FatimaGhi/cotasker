class Project {
  String? id;
  String? userId;
  String title;
  DateTime dateStart;
  DateTime dateEnd;
  String etat;
  String commentaire;
  int nTask;

  Project({
    required this.userId,
    required this.title,
    required this.dateStart,
    required this.dateEnd,
    required this.etat,
    required this.commentaire,
    required this.nTask,
  });

  // Convert a Project object into a map
  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'userId': userId,
      'title': title,
      'dateStart': dateStart.toIso8601String(),
      'dateEnd': dateEnd.toIso8601String(),
      'etat': etat,
      'commentaire': commentaire,
      'nTask': nTask,
    };
  }

  // Create a Project object from a map
  factory Project.fromMap(Map<String, dynamic> map) {
    return Project(
      // id: map['id'],
      userId: map['userId'],
      title: map['title'],
      dateStart:
          DateTime.parse(map['dateStart'] ?? DateTime.now().toIso8601String()),
      dateEnd:
          DateTime.parse(map['dateEnd'] ?? DateTime.now().toIso8601String()),
      etat: map['etat'],
      commentaire: map['commentaire'],
      nTask: map['nTask'],
    );
  }
}
