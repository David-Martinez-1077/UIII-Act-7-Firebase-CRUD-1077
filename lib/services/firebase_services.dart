import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

// Obtener todos los cursos
Future<List> getCourses() async {
  List courses = [];
  CollectionReference collectionReference = db.collection("cursos");
  QuerySnapshot queryCourses =
      await collectionReference.orderBy('created_at', descending: true).get();

  for (var doc in queryCourses.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final course = {
      'title': data['title'],
      'description': data['description'],
      'instructor_id': data['instructor_id'],
      'price': data['price'],
      'category': data['category'],
      'created_at': data['created_at'],
      'uid': doc.id,
    };
    courses.add(course);
  }

  return courses;
}

// Añadir un nuevo curso
Future<void> addCourse(
  String title,
  String description,
  String instructorId,
  double price,
  String category,
) async {
  await db.collection("cursos").add({
    'title': title,
    'description': description,
    'instructor_id': instructorId,
    'price': price,
    'category': category,
    'created_at': DateTime.now(),
  });
}

// Actualizar un curso
Future<void> updateCourse(
  String uid,
  String title,
  String description,
  String instructorId,
  double price,
  String category,
) async {
  await db.collection('cursos').doc(uid).update({
    'title': title,
    'description': description,
    'instructor_id': instructorId,
    'price': price,
    'category': category,
  });
}

// Eliminar un curso
Future<void> deleteCourse(String uid) async {
  await db.collection('cursos').doc(uid).delete();
}
