import 'dart:io';
import 'package:book_app_flutter/firebase/firestore_storage.dart';
import 'package:book_app_flutter/screens/pdf_viewer_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../model/book_model.dart';
import 'package:http/http.dart' as http;

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final BookFirebaseFirestore _storage = BookFirebaseFirestore();
  List<BookModel> _bookList = [];
  late bool response = false;

  @override
  void initState() {
    super.initState();
    _loadBookModels();
  }

  Future<void> _loadBookModels() async {
    List<BookModel> books = (await _storage.getBooks()).cast<BookModel>();
    response = true;
    setState(() {
      _bookList = books;
    });
  }

  Future<File> download(String url) async {
    return await _storage.loadBook(url, (i, total) {
      print("$i:$total");
    });
  }

  @override
  Widget build(BuildContext context) {
    if (response) {
      return Scaffold(
        appBar: AppBar(title: const Text("The worlds of books")),
        body: Container(
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
                itemCount: _bookList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      download(_bookList[index].url).then((value) => {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => PdfViewerPage(path:value.path) ))
                          });
                    },
                    child: Card(
                        child: Column(
                      children: [
                        const SizedBox(height: 10),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              _bookList[index].img_url,
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            )),
                        const SizedBox(height: 10),
                        Text(_bookList[index].author, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        Text(_bookList[index].title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Text(_bookList[index].description /*, maxLines: 3, overflow: TextOverflow.ellipsis*/)),
                        const SizedBox(height: 10),
                      ],
                    )),
                  );
                })),
      );
    } else {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
  }
}
