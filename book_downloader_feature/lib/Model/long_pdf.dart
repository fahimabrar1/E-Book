// class LongPDFViewer {
//   // Future<void> generatePdf() async {}
// }

//
// class LongPDFViewer extends pw.StatefulWidget {
//   const LongPDFViewer({Key? key}) : super(key: key);
//
//   @override
//   State<LongPDFViewer> createState() => _LongPDFViewerState();
// }
//
// class _LongPDFViewerState extends State<LongPDFViewer> {
//   final pdf = pw.Document();
//   late pdfx.PdfController pdfController;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     pdf.addPage(pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return pw.Center(
//             child: pw.Text("Hello World"),
//           ); // Center
//         }));
//
//     pdfController = pdfx.PdfController(
//         document: loadDocument(), );
//     super.initState();
//   } // Page
//
//   @override
//   Widget build(BuildContext context) {
//     return PdfView(
//       controller: pdfController,
//       onDocumentLoaded: (doc) {},
//       onPageChanged: (Page) {
//         setState(() {
//           // page = Page;
//           // widget.book.lastPageReaded = Page;
//           // calculatePercentage();
//         });
//       },
//     );
//   }
//
//   Future<pdfx.PdfDocument> loadDocument() async {
//     return  pdf.document;
//   }
// }
