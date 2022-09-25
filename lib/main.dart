import 'package:flutter/material.dart';
import 'package:todo_list2/pages/lista_tarefas_page.dart';

void main() {
  runApp(const ListaTarefasApp());
}

class ListaTarefasApp extends StatefulWidget {
  const ListaTarefasApp({super.key});

  @override
  State<ListaTarefasApp> createState() => _ListaTarefasAppState();
}

class _ListaTarefasAppState extends State<ListaTarefasApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de tarefas',
      theme: ThemeData(
        hintColor: Colors.lightBlue,
        primaryColor: Colors.lightBlue,
        primarySwatch: Colors.blue,
        canvasColor: Colors.white,
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 1),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
        ),
      ),
      home: const ListaTarefasPage(),
    );
  }
}
