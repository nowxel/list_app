import 'package:flutter/material.dart';
import 'package:list_app/bloc/item_bloc.dart';
import 'package:list_app/screen/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemBloc>(
      bloc: ItemBloc(),
      child: const MaterialApp(
        title: 'List App',
        home: MyHomePage(),
      ),
    );
  }
}
