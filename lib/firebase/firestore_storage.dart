import 'dart:io';
import 'package:path/path.dart';
import 'package:book_app_flutter/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class BookFirebaseFirestore {
  final _db = FirebaseFirestore.instance; // Firestore cloud init qilish uchun
  final _storage = FirebaseStorage.instance.ref();
  late DownloadTask snap;

  // Future<List<String>> getBookss() async {
  //   final list = (await _storage.ref().list()).items;
  //   final urls = <String>[];
  //   for (int i = 0; i < list.length; i++) {
  //     urls.add(await list[i].getDownloadURL());
  //   }
  //   return urls;
  // }

  Future<List<BookModel>> getBooks() async {
    List<BookModel> booksList = [];
    var querySnapshot = await _db
        .collection("books")
        // .withConverter<BookModel>(
        // fromFirestore: (snapshots, _) => BookModel.fromJson(snapshots.data()!),
        // toFirestore: (book, _) => {})
        .get();
    for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
      BookModel bookModel = BookModel.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      booksList.add(bookModel);
    }
    return booksList;
  }

  Future<File> loadBook(String url, Function(int count, int total) progress) async {
    final fileName = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    final refPDF = _storage.child(url);
    var file = File('${dir.path}/$fileName');
    await file.writeAsBytes(await refPDF.getData() as List<int>);

    snap = refPDF.writeToFile(file);
    await Future.delayed(const Duration(microseconds: 200));
    final snapshot = snap.snapshotEvents;

    print("path: ${dir.path}/$fileName");

    snapshot.listen((event) {
      switch (event.state) {
        case TaskState.paused:
          print("paused");
          break;
        case TaskState.running:
          print("running");
          print("${event.totalBytes} / ${event.bytesTransferred}");
          print("${event.bytesTransferred / (event.totalBytes / 100)} % ");
          break;
        case TaskState.success:
          print("success");
          break;
        case TaskState.canceled:
          print("canceled");
          break;
        case TaskState.error:
          print("error");
          break;
      }
    });

    final bytes = await refPDF.getData();

    return file;
  }
}
