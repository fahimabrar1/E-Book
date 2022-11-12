import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:book_reader/Screens/Model/book.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_bloc.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_event.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_state.dart';
import 'package:book_reader/Screens/my_homepage.dart';
import 'package:book_reader/Screens/pdf_view.dart';
import 'package:book_reader/Utils/global_variable.dart';
import 'package:book_reader/Utils/my_librabry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class BookSinglePage extends StatefulWidget {
  final Book book;
  final int bookIndex;
  const BookSinglePage({
    required this.book,
    required this.bookIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<BookSinglePage> createState() => _BookSinglePageState();
}

class _BookSinglePageState extends State<BookSinglePage> {
  ReceivePort receivePort = ReceivePort();
  int progress = 0;
  Map<String, int> download_map = {};

  @override
  void initState() {
    // TODO: implement initState
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, 'downloader_send_port');
    receivePort.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (status == DownloadTaskStatus.enqueued) {
        log("message enqueued");
      } else if (status == DownloadTaskStatus.complete) {
        log("message complete");
        setCompletedDownload(id);
      } else if (status == DownloadTaskStatus.failed) {
        log("message failed");
      }
      setState(() {});
    });
    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return const MyHomePage();
                            },
                          ),
                          (_) => false,
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Book Details",
                      style: MyCustomFonts.getRubik(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontColor: Colors.black45,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                )
              ],
            ),
            Container(
              height: 300,
              child: Center(child: Image.asset(widget.book.imgPath)),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.book.name,
                  style: MyCustomFonts.getDmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontColor: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Rating",
                          style: MyCustomFonts.getDmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontColor: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.book.rating.toString(),
                          style: MyCustomFonts.getRubik(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Page",
                          style: MyCustomFonts.getDmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontColor: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.book.pages.toString(),
                          style: MyCustomFonts.getRubik(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Language",
                          style: MyCustomFonts.getDmSans(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontColor: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.book.language,
                          style: MyCustomFonts.getRubik(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontColor: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Text(
                widget.book.expert,
                style: MyCustomFonts.getRubik(
                  fontSize: 12,
                  fontColor: Colors.black54,
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(vertical: 15),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(MyCustomColors.green),
                      ),
                      onPressed: () {
                        PersistentNavBarNavigator.pushNewScreen(
                          context,
                          screen: BlocProvider.value(
                            value: context.read<BookblocBloc>(),
                            child: PDFViewPage(
                              book: widget.book,
                              bookIndex: widget.bookIndex,
                            ),
                          ),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                        );
                      },
                      child: const Text("Read"),
                    ),
                  ),
                ),
                BlocBuilder<BookblocBloc, BookblocState>(
                    buildWhen: (previous, current) {
                  if (current is BookblocStateChangePercentage) {
                    log("Is BookblocStateChangePercentage");
                  } else if (current is BookblocInitial) {
                    log("Is BookblocInitial");
                  } else {
                    log("Is Book");
                  }
                  return true;
                }, builder: (context, state) {
                  var a = state.props.first as List<Book>;
                  // log("Book Name: " + a[index].name.toString());
                  // log("Book read percentage: " + a[index].readPercentage.toString());

                  return (!widget.book.downloaded!)
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(vertical: 15),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    MyCustomColors.lightBrown),
                              ),
                              onPressed: () {
                                downloadFile(widget.bookIndex);
                              },
                              child: const Text("Download"),
                            ),
                          ),
                        )
                      : SizedBox();
                  // return widget here based on BlocA's state
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? sendPort =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    sendPort!.send([id, status, progress]);
  }

  Future downloadFile(int index) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();

      log("Path: " + baseStorage!.path);

      String? id = await FlutterDownloader.enqueue(
          url:
              "https://github.com/fahimabrar1/E-Book/blob/main/assets/pdfs/book1.pdf",
          // "https://www.africau.edu/images/default/sample.pdf",

          savedDir: baseStorage.path,
          showNotification:
              true, // show download progress in status bar(forAndroid)
          openFileFromNotification:
              true, // click on notification to open downloaded file (for Android)

          fileName: "book1.pdf");
      download_map.addAll({id!: index});
    }
  }

  void setCompletedDownload(String id) {
    if (download_map.containsKey(id)) {
      int value = download_map[id]!;

      setState(() {
        bookList[value].downloaded = true;
        BlocProvider.of<BookblocBloc>(context).add(OnRefreshBE(bookList));
      });
    }
  }
}
