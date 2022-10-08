import 'package:book_reader/Screens/Model/book.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_bloc.dart';
import 'package:book_reader/Screens/my_homepage.dart';
import 'package:book_reader/Screens/pdf_view.dart';
import 'package:book_reader/Utils/my_librabry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                          screen: BlocProvider<BookblocBloc>.value(
                            value: BlocProvider.of<BookblocBloc>(context),
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
                Expanded(
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
                      onPressed: () {},
                      child: const Text("Download"),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
