import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<DocumentSnapshot> fetchUser() async{
  final user = await FirebaseAuth.instance.currentUser();
  final userDbRecordSet =  await Firestore.instance.collection('users').where('uid', isEqualTo: user.uid).limit(1).getDocuments();
  final userDbRecord = userDbRecordSet.documents[0];
  return userDbRecord;
}
