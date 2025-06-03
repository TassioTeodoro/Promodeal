// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:promodeal/firebase_options.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:promodeal/models/account.dart';
import 'package:promodeal/models/post.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
 test("Create a post", () {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  CollectionReference ref = firestore.collection("users");

  DocumentReference docRef = ref.add(Account(bio: "", businessLocation: ["0", "0"], email: "aweoasodaos@awoeaoseo.com", isBusiness: false, username: "Rogerio").toMap()) as DocumentReference<Object?>;

  expect(docRef,(ref) => {
    ref != null
  } );
 });
}
