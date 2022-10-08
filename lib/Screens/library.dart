import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:book_reader/Screens/Model/book.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_bloc.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_event.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_state.dart';
import 'package:book_reader/Screens/pdf_view.dart';
import 'package:book_reader/Utils/global_variable.dart';
import 'package:book_reader/Utils/my_librabry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  ReceivePort receivePort = ReceivePort();
  int progress = 0;
  Map<String, int> download_map = {};

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Text(
            "Library",
            style: MyCustomFonts.getDmSans(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              fontColor: Colors.black87,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookList.length,
            itemBuilder: (itemBuilder, index) {
              return bookPanel(index);
            })
      ],
    );
  }

  Widget bookPanel(int index) {
    return Card(
      child: Row(
        children: [
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(bookList.elementAt(index).imgPath),
            ),
          ),
          SizedBox(
            width: 120,
            child: Text(
              bookList.elementAt(index).name,
              maxLines: 2,
              overflow: TextOverflow.fade,
              style: MyCustomFonts.getRubik(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontColor: Colors.black87,
              ),
            ),
          ),
          const Spacer(),
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

            return Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: 1,
                  color: MyCustomColors.green.withAlpha(50),
                ),
                CircularProgressIndicator(
                  value: a[index].readPercentage,
                  color: MyCustomColors.green,
                ),
                Text(
                  "${a[index].readPercentage! * 100}%",
                  style: MyCustomFonts.getRubik(
                    fontSize: 8,
                    fontWeight: FontWeight.w600,
                    fontColor: MyCustomColors.darkGreen,
                  ),
                ),
              ],
            );
            // return widget here based on BlocA's state
          }),
          IconButton(
            onPressed: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: BlocProvider<BookblocBloc>.value(
                  value: context.read<BookblocBloc>(),
                  child: PDFViewPage(
                    book: bookList.elementAt(index),
                    bookIndex: index,
                  ),
                ),
                withNavBar: false, // OPTIONAL VALUE. True by default.
              );
            },
            icon: const Icon(
              Icons.remove_red_eye,
              color: MyCustomColors.lightBrown,
            ),
          ),
          (!bookList.elementAt(index).downloaded)
              ? IconButton(
                  onPressed: () {
                    downloadFile(index);
                  },
                  icon: const Icon(Icons.download),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  void initState() {
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
