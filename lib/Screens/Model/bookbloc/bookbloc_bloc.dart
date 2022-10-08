import 'dart:developer';

import 'package:book_reader/Screens/Model/bookbloc/bookbloc_event.dart';
import 'package:book_reader/Screens/Model/bookbloc/bookbloc_state.dart';
import 'package:book_reader/Utils/global_variable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookblocBloc extends Bloc<BookblocEvent, BookblocState> {
  BookblocBloc() : super(BookblocInitial(bookList)) {
    on<BookblocEvent>((event, emit) {
      log("Called Change Event");
    });
    on<OnChangeBookPercentageBE>((event, emit) {
      log("Called Change");
      if (event.bookListBE.isNotEmpty) {
        emit(BookblocStateChangePercentage(event.bookListBE));
      } else {
        log("Empty");
      }

      emit(BookblocInitial(event.bookListBE));
    });

    on<OnRefreshBE>((event, emit) {
      emit(BookblocRefreshState());
      emit(BookblocInitial(event.bookListBE));
    });
  }
}
