import 'package:employee_manager/cubits/employee_cubit.dart';
import 'package:employee_manager/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          // #1DA1F2
          backgroundColor: Colors.lightBlue,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.lightBlue,
          
        ),
        dialogTheme: const DialogTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
          contentTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        //Textformfield to have a border
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.lightBlue,
            ),
          ),
        ),
      );
    var materialApp = MaterialApp(
      title: 'Employee Manager',
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => EmployeeCubit(),
        child: const HomePage(),
      ),
    );
    return materialApp;
  }
}
