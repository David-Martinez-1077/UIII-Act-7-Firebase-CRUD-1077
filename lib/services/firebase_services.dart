import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getPeople() async {
  List people = [];
  CollectionReference collectionReferencePeople = db.collection("people");
  QuerySnapshot queryPeople = await collectionReferencePeople.get();
  for (var doc in queryPeople.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    final person = {
      'name': data['name'],
      'uid': doc.id
    };
    people.add(person);
  }

  await Future.delayed(Duration(seconds: 2));

  return people;
}

Future<void> addPeople(String name) async {
  await db.collection("people").add({"name": name});
}

Future<void> updatePeople(String uid, String newName) async {
  await db.collection('people').doc(uid).set({'name': newName});
}

Future<void> deletePeople(String uid) async {
  await db.collection('people').doc(uid).delete();
}
