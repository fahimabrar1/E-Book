import 'dart:developer';

import 'package:book_downloader_feature/Model/book_model.dart';
import 'package:book_downloader_feature/Utils/my_library.dart';
import 'package:dio/dio.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('File Downloader Feature');
  late List<BookModel> tempBookList;
  bool anyReportSelected = false;
  late double progVal;
  late int totalByte;
  late int totalByteReceived;
  late bool showDownloadProgess;
  var dio = Dio();
  Map<String, BookMapper> map = {};

  List<BookModel> bookList = [
    BookModel(
        title: "Book 1",
        url:
            "https://github.com/ScerIO/packages.flutter/raw/fd0c92ac83ee355255acb306251b1adfeb2f2fd6/packages/native_pdf_renderer/example/assets/sample.pdf",
        id: "abcd",
        selected: false),
    BookModel(
        title: "Book 2",
        url:
            "https://github.com/ScerIO/packages.flutter/raw/fd0c92ac83ee355255acb306251b1adfeb2f2fd6/packages/native_pdf_renderer/example/assets/sample.pdf",
        id: "abdc",
        selected: false),
    BookModel(
        title: "Book 3",
        url:
            "https://github.com/ScerIO/packages.flutter/raw/fd0c92ac83ee355255acb306251b1adfeb2f2fd6/packages/native_pdf_renderer/example/assets/sample.pdf",
        id: "acd",
        selected: false),
    BookModel(
        title: "Book 4",
        url:
            "https://github.com/ScerIO/packages.flutter/raw/fd0c92ac83ee355255acb306251b1adfeb2f2fd6/packages/native_pdf_renderer/example/assets/sample.pdf",
        id: "bcd",
        selected: false),
    BookModel(
        title: "Book 5",
        url:
            "https://github.com/ScerIO/packages.flutter/raw/fd0c92ac83ee355255acb306251b1adfeb2f2fd6/packages/native_pdf_renderer/example/assets/sample.pdf",
        id: "bcad",
        selected: false),
    BookModel(
        title: "Book 6",
        url:
            "https://github.com/ScerIO/packages.flutter/raw/fd0c92ac83ee355255acb306251b1adfeb2f2fd6/packages/native_pdf_renderer/example/assets/sample.pdf",
        id: "cbad",
        selected: false),
  ];

  late List<DownloadTask> tasks;
  @override
  void initState() {
    progVal = 0;
    totalByte = 0;
    totalByteReceived = 0;
    showDownloadProgess = false;
    tempBookList = bookList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (customIcon.icon == Icons.search) {
                  customIcon = const Icon(Icons.cancel);
                  customSearchBar = ListTile(
                    leading: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                    title: TextField(
                      decoration: const InputDecoration(
                        hintText: 'type in journal name...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: onSearchValueChange,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  );
                } else {
                  onSearchValueChange("");
                  customIcon = const Icon(Icons.search);
                  customSearchBar = const Text('My Personal Journal');
                }
              });
            },
            icon: customIcon,
          ),
          (anyReportSelected)
              ? IconButton(
                  onPressed: onPressDownloadButton,
                  icon: const Icon(
                    Icons.download_rounded,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            ListView.separated(
              itemCount: tempBookList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                  ),
                  title: Text('ID: ${tempBookList[index].id}'),
                  subtitle: Text(tempBookList[index].title),
                  selected: tempBookList[index].selected,
                  selectedColor: Colors.lightBlueAccent,
                  selectedTileColor: Colors.lightBlueAccent.withAlpha(30),
                  onLongPress: () {
                    setState(() {
                      // tempBookList[index].selected = !tempBookList[index].selected;
                      bookList
                          .singleWhere(
                              (element) => element.id == tempBookList[index].id)
                          .selected = !tempBookList[index].selected;

                      for (var tempBook in bookList) {
                        if (tempBook.selected) {
                          anyReportSelected = true;
                          break;
                        } else {
                          anyReportSelected = false;
                        }
                      }
                    });
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
            (showDownloadProgess)
                ? Column(children: [
                    Expanded(
                      child: Container(
                        color: Colors.black26,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text("${progVal * 100}"),
                                          Text("/100"),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      alignment: Alignment.bottomCenter,
                                      child: LinearProgressIndicator(
                                        value: progVal,
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      alignment: Alignment.centerRight,
                                      child: TextButton(
                                          onPressed: () {
                                            setState(() {
                                              showDownloadProgess = false;
                                            });
                                          },
                                          child: Text("Cancel")),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ])
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  void onSearchValueChange(String value) {
    setState(() {
      tempBookList = bookList.where((book) => book.id.contains(value)).toList();
    });
  }

  void onPressDownloadButton() async {
    // Directory dir = await getApplicationDocumentsDirectory();

    final baseStorage = await getExternalStorageDirectory();
    log("Selected Books: ${tempBookList.length}");
    log("Path: ${baseStorage!.absolute.path}");
    List<Future<dynamic>> dioList = [];
    setState(() {
      showDownloadProgess = true;
    });
    for (var book in tempBookList) {
      if (book.selected) {
        dioList.add(dio.download(
          book.url,
          "${baseStorage.absolute.path}/${book.title}",
          onReceiveProgress: (rcv, total) {
            setState(() {
              map[book.id] = BookMapper(perRcv: rcv, perTotal: total);
              totalByte = 0;
              totalByteReceived = 0;
              map.forEach((key, value) {
                totalByteReceived += value.perRcv!;
                totalByte += value.perTotal!;
                progVal = double.parse(
                    (totalByteReceived / totalByte).toStringAsFixed(2));
              });
              if (totalByte == totalByteReceived) {
                log("toal rcv: $totalByteReceived     , total: $totalByte");
                showDownloadProgess = false;
                progVal = 0;
              }
            });
          },
        ));
      }
    }

    Future.wait(dioList);
    log("Downloaded");
  }
}

class BookMapper {
  int? perRcv;
  int? perTotal;

  BookMapper({required this.perRcv, required this.perTotal});
}
