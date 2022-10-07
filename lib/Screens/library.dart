import 'dart:developer';

import 'package:book_reader/Screens/Model/book.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_bloc.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_state.dart';
import 'package:book_reader/Screens/pdf_view.dart';
import 'package:book_reader/Utils/global_variable.dart';
import 'package:book_reader/Utils/my_librabry.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  late BookblocBloc bookBloc;

  @override
  void initState() {
    bookBloc = BookblocBloc();
    super.initState();
  }

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
            log("Book Name: " + a[index].name.toString());
            log("Book read percentage: " + a[index].readPercentage.toString());

            return (!a[index].downloaded)
                ? Stack(
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
                  )
                : Container();
            // return widget here based on BlocA's state
          }),
          // BlocSelector<BookblocBloc, BookblocState, List<Book>>(
          //     selector: (state) {
          //   var a = state.props.first as List<Book>;
          //   // for (var element in a) {
          //   // log("Book Name: " + element.name.toString());
          //   // log("Book read percentage: " + element.readPercentage.toString());
          //   // }
          //   return a;
          // }, builder: (context, state) {

          // }),

          // (!bookList.elementAt(index).downloaded)
          //     ? Stack(
          //         alignment: Alignment.center,
          //         children: [
          //           CircularProgressIndicator(
          //             value: 1,
          //             color: MyCustomColors.green.withAlpha(50),
          //           ),
          //           CircularProgressIndicator(
          //             value: bookList.elementAt(index).readPercentage,
          //             color: MyCustomColors.green,
          //           ),
          //           Text(
          //             "${bookList.elementAt(index).readPercentage! * 100}%",
          //             style: MyCustomFonts.getRubik(
          //               fontSize: 8,
          //               fontWeight: FontWeight.w600,
          //               fontColor: MyCustomColors.darkGreen,
          //             ),
          //           ),
          //         ],
          //       )
          //     : Container(),
          (!bookList.elementAt(index).downloaded)
              ? IconButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: BlocProvider<BookblocBloc>.value(
                        value: BlocProvider.of<BookblocBloc>(context),
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
                )
              : Container(),
          (!bookList.elementAt(index).downloaded && index != 1)
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.download),
                )
              : Container(),
        ],
      ),
    );
  }
}
