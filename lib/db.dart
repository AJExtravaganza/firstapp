import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/tea.dart';

Future<DocumentSnapshot> fetchUser() async{
  final user = await FirebaseAuth.instance.currentUser();
  final userDbRecordSet =  await Firestore.instance.collection('users').where('uid', isEqualTo: user.uid).limit(1).getDocuments();
  final userDbRecord = userDbRecordSet.documents[0];
  return userDbRecord;
}

Future<List<DocumentSnapshot>> fetchUserStashContents() async {
  final user = await fetchUser();
  final teasInStash = await user.reference.collection('teas_in_stash').getDocuments();
  return teasInStash.documents;
}

//void putInUserStash(Tea tea) async {
//final user = await fetchUser();
//user.reference.collection('teas_in_stash').add(tea);
//}

Future<List<DocumentSnapshot>> fetchTeaProducers() async {
  final producers = await Firestore.instance.collection('tea_producers').getDocuments();
  return producers.documents;
}

Future<List<DocumentSnapshot>> fetchTeaProductions() async{
  final productions = await Firestore.instance.collection('tea_productions').getDocuments();
  return productions.documents;
}