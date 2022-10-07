import 'package:book_reader/Screens/Model/book.dart';
import 'package:equatable/equatable.dart';

abstract class BookblocState extends Equatable {}

class BookblocInitial extends BookblocState {
  late List<Book> bookBlocList;
  BookblocInitial(this.bookBlocList);
  @override
  List<Object?> get props => [this.bookBlocList];
}

class BookblocStateChangePercentage extends BookblocState {
  late List<Book> bookBlocList;
  BookblocStateChangePercentage(this.bookBlocList);

  @override
  List<Object?> get props => [this.bookBlocList];
}

class BookblocResetState extends BookblocState {
  @override
  List<Object?> get props => [];
}
