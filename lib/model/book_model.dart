import 'dart:core';

class BookModel {
  String title;
  String url;
  String author;
  String description;
  String img_url;

  BookModel({required this.title, required this.url, required this.author, required this.description, required this.img_url});

  factory BookModel.fromJson(Map<String, dynamic> json) =>
      BookModel(title: json['title'], url: json['url'], author: json['author'], description: json['description'], img_url: json['img_url']);
}
