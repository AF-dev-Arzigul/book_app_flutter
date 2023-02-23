import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import '../firebase/firestore_storage.dart';

final di = GetIt.instance;

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  di.registerSingleton(BookFirebaseFirestore());
}
