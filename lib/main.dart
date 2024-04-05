import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_apps/bloc/user_bloc.dart';
import 'package:sqflite_apps/pages/user_page.dart';

void main() {
  runApp(const SqfliteApps());
}

class SqfliteApps extends StatelessWidget {
  const SqfliteApps({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sqflite Apps',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const UserPage(),
      ),
    );
  }
}
