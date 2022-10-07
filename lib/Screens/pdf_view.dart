import 'dart:developer';

import 'package:book_reader/Screens/Model/book.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_bloc.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_event.dart';
import 'package:book_reader/Utils/global_variable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    pdfController = PdfController(
        document: PdfDocument.openAsset(widget.book.pdfPath),
        initialPage: widget.book.lastPageReaded ??= 1);
    page = widget.book.lastPageReaded ??= 1;
    // log("page NUmber: " + page.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: PdfPageNumber(
                  controller: pdfController,
                  // When `loadingState != PdfLoadingState.success`  `pagesCount` equals null_
                  builder: (_, state, loadingState, pagesCount) => Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                      '$page/${pagesCount ?? 0}',
                      style: const TextStyle(fontSize: 21, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: PdfView(
                  controller: pdfController,
                  onPageChanged: (Page) {
                    setState(() {
                      page = Page;
                      widget.book.lastPageReaded = Page;

                      try {
                        double d = (page / (pdfController.pagesCount ?? 0));
                        widget.book.readPercentage =
                            double.parse(d.toStringAsFixed(2)); // 2.35

                        log(widget.book.readPercentage.toString());
                        bookList[widget.bookIndex] = widget.book;

                        BlocProvider.of<BookblocBloc>(context)
                            .add(OnChangeBookPercentageBE(bookList));
                      } catch (e) {
                        widget.book.readPercentage = 0;
                      }
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
