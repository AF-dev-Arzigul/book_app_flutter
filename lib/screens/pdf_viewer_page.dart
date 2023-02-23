import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';


class PdfViewerPage extends StatelessWidget {
  final String path;

  const PdfViewerPage({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: path,
      fitEachPage: true,
      pdfData: Uint8List(50),
      onPageChanged: (i, j) {},
    );
    ;
  }
}
