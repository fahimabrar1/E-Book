import 'dart:convert';
import 'dart:math';

class Book {
  String name;
  String expert;
  String imgPath;
  String pdfPath;
  double rating;
  int pages;
  String language;
  late String id;
  late int? lastPageReaded;
  late bool downloaded;
  late double? readPercentage;

  Book({
    required this.name,
    required this.expert,
    required this.imgPath,
    required this.pdfPath,
    required this.rating,
    required this.pages,
    required this.language,
    this.readPercentage,
    this.lastPageReaded,
  }) {
    id = getBase64RandomString(6);
    downloaded = false;
    readPercentage ??= 0;
    lastPageReaded ??= 1;
    print(id.toString());
  }

  String getBase64RandomString(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
