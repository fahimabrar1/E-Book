import 'package:book_reader/Screens/Model/book.dart';
import 'package:equatable/equatable.dart';

abstract class BookblocEvent extends Equatable {}

class OnChangeBookPercentageBE extends BookblocEvent {
  late List<Book> bookListBE;
  OnChangeBookPercentageBE(this.bookListBE);
  @override
  List<Object?> get props => [this.bookListBE];
}
