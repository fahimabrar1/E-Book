import 'dart:developer';

import 'package:book_reader/Screens/Model/book.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_bloc.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_event.dart';
import 'package:book_reader/Utils/global_variable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_file/internet_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../Utils/my_librabry.dart';

class PDFViewPage extends StatefulWidget {
  final Book book;
  final int bookIndex;

  const PDFViewPage({required this.book, required this.bookIndex, Key? key})
      : super(key: key);

  @override
  State<PDFViewPage> createState() => _PDFViewPageState();
}

class _PDFViewPageState extends State<PDFViewPage> {
  late PdfController pdfController;
  late int page;
  late bool intiVIew;

  @override
  void initState() {
    intiVIew = false;
    // log("page NUmber: " + page.toString());
    getPath().then((doc) {
      setState(() {
        log("Init");
        pdfController = PdfController(
            document: doc, initialPage: widget.book.lastPageReaded ??= 1);
        page = widget.book.lastPageReaded ??= 1;
        intiVIew = true;
      });
    });
    super.initState();
  }

  Future<Future<PdfDocument>> getPath() async {
    Future<PdfDocument> doc;
    if (!widget.book.downloaded) {
      log("Opening Via Network");
      log("path: " + widget.book.pdfPath);
      doc = PdfDocument.openData(InternetFile.get(widget.book.pdfPath));
      log("Success");
    } else {
      final basepath = await getExternalStorageDirectory();
      log("Opening Via Local");
      log("path: " + basepath!.path + "/book1.pdf");

      doc = PdfDocument.openFile(basepath.path + "/book1.pdf");
      log("Success");
    }
    log("Return");
    return doc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              (intiVIew)
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PdfPageNumber(
                          controller: pdfController,

                          // When `loadingState != PdfLoadingState.success`  `pagesCount` equals null_
                          builder: (_, state, loadingState, pagesCount) {
                            log("PdfLoadingState " + state.toString());

                            if (state == PdfLoadingState.success) {
                              log("PdfLoadingState.success");
                              return Container(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  '$page/${pagesCount ?? 0}',
                                  style: const TextStyle(
                                      fontSize: 21, color: Colors.white),
                                ),
                              );
                            } else if (state == PdfLoadingState.loading) {
                              return Row(
                                children: const [
                                  Expanded(
                                      child: Center(
                                          child: CircularProgressIndicator())),
                                ],
                              );
                            } else {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Error Loading header",
                                      textAlign: TextAlign.center,
                                      style: MyCustomFonts.getRubik(
                                          fontSize: 12,
                                          fontColor: Colors.white),
                                    ),
                                  ),
                                ],
                              );
                            }
                          }),
                    )
                  : Row(
                      children: const [Expanded(child: SizedBox())],
                    ),
              Expanded(
                child: (intiVIew)
                    ? PdfView(
                        controller: pdfController,
                        onDocumentLoaded: (doc) {
                          calculatePercentage();
                        },
                        onPageChanged: (Page) {
                          setState(() {
                            page = Page;
                            widget.book.lastPageReaded = Page;
                            calculatePercentage();
                          });
                        },
                      )
                    : Center(child: CircularProgressIndicator()),
              )
            ],
          ),
        ),
      ),
    );
  }

  void calculatePercentage() {
    try {
      double d = (page / (pdfController.pagesCount ?? 1));
      widget.book.readPercentage = double.parse(d.toStringAsFixed(2)); // 2.35

      log(widget.book.readPercentage.toString());
      bookList[widget.bookIndex] = widget.book;

      BlocProvider.of<BookblocBloc>(context)
          .add(OnChangeBookPercentageBE(bookList));
    } catch (e) {
      widget.book.readPercentage = 0;
    }
  }
}
