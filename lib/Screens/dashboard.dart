import 'package:book_reader/Screens/BookScreen/book_single.dart';
import 'package:book_reader/Utils/global_variable.dart';
import 'package:book_reader/Utils/my_librabry.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class DashBoard extends StatefulWidget {
  final bool hideNavBar;
  final Function onScreenHideButtonPressed;

  const DashBoard(
      {Key? key,
      required this.hideNavBar,
      required this.onScreenHideButtonPressed})
      : super(key: key);
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.menu,
                    color: Colors.grey.shade500,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.grey.shade500,
                  ),
                ),
                const CircleAvatar(
                  backgroundColor: MyCustomColors.green,
                ),
              ],
            ),
            trendingBooks(),
          ],
        ),
      ),
    );
  }

  Widget trendingBooks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Trending Books",
              style: MyCustomFonts.getDmSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontColor: Colors.black87,
              ),
            ),
          ),
          SizedBox(
            height: 360,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: bookList.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 150,
                  // color: Colors.amber,
                  margin: (index > 0)
                      ? (index == bookList.length - 1)
                          ? const EdgeInsets.only(left: 5, top: 10, bottom: 10)
                          : const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10)
                      : const EdgeInsets.only(right: 5, top: 10, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: BookSinglePage(
                          book: bookList.elementAt(index),
                        ),
                        withNavBar: false, // OPTIONAL VALUE. True by default.
                      );
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AspectRatio(
                          aspectRatio: 0.6,
                          child: Container(
                            height: 180,
                            // color: Colors.blue,
                            child: Image.asset(
                              bookList.elementAt(index).imgPath,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            bookList.elementAt(index).name,
                            overflow: TextOverflow.fade,
                            maxLines: 2,
                            style: MyCustomFonts.getDmSans(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            bookList.elementAt(index).expert,
                            overflow: TextOverflow.fade,
                            maxLines: 3,
                            softWrap: true,
                            style: MyCustomFonts.getRubik(
                              fontSize: 10,
                              fontColor: Colors.grey.shade500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
