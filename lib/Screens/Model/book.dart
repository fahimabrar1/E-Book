import 'dart:convert';
import 'dart:math';

class Book {
  String name;
  String expert;
  String imgPath;
  double rating;
  int pages;
  String language;
  late String id;
  Book({
    required this.name,
    required this.expert,
    required this.imgPath,
    required this.rating,
    required this.pages,
    required this.language,
  }) {
    id = getBase64RandomString(6);
    print(id.toString());
  }

  String getBase64RandomString(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
