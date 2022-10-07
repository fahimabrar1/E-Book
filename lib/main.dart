import 'package:book_reader/Screens/Model/bookbloc/bookbloc_bloc.dart';
import 'package:book_reader/Screens/my_homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Book',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(providers: [
        BlocProvider<BookblocBloc>(
          create: (BuildContext context) => BookblocBloc(),
        ),
      ], child: const MyHomePage()),
    );
  }
}
