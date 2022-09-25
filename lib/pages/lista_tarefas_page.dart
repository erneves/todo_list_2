import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ListaTarefasPage extends StatefulWidget {
  const ListaTarefasPage({Key? key}) : super(key: key);

  @override
  State<ListaTarefasPage> createState() => _ListaTarefasPageState();
}

class _ListaTarefasPageState extends State<ListaTarefasPage> {
  TextEditingController tarefaController = TextEditingController();

  static const titulo = 'titulo';
  static const ok = 'ok';

  List _todoList = [];
  late Map<String, dynamic> _lastRemoved;
  late int _lastRemovedPos;

  @override
  void initState() {
    _readData().then((value) {
      if (value != null && value.isNotEmpty) {
        setState(() {
          _todoList = json.decode(value);
        });
      }
    });
    super.initState();
  }

  void _adicionarTarefa() {
    setState(() {
      Map<String, dynamic> tarefa = {};
      tarefa[titulo] = tarefaController.text;
      tarefa[ok] = false;
      _todoList.add(tarefa);
      tarefaController.text = '';
      _saveData();
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _todoList.sort((a, b) {
        if (a[ok] && !b[ok]) {
          return 1;
        } else if (!a[ok] && b[ok]) {
          return -1;
        } else {
          return 0;
        }
      });
      _saveData();
    });
  }

  Future<File> _getArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File('${diretorio.path}/data.json');
  }

  Future<File> _saveData() async {
    String data = json.encode(_todoList);
    final arquivo = await _getArquivo();
    return arquivo.writeAsString(data);
  }

  Future<String?> _readData() async {
    try {
      final arquivo = await _getArquivo();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: tarefaController,
                    decoration: const InputDecoration(
                      labelText: 'Nova tarefa',
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: _adicionarTarefa,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                  ),
                  child: const Icon(Icons.add_task, size: 30),
                ),
              ],
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: ListView.builder(
                  itemCount: _todoList.length,
                  itemBuilder: buildItem,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(context, index) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        _lastRemoved = Map.from(_todoList[index]);
        _lastRemovedPos = index;
        _todoList.removeAt(index);
        _saveData();

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Tarefa \"${_lastRemoved[titulo]}\" removida!"),
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                setState(() {
                  _todoList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                });
              }),
          duration: const Duration(seconds: 5),
        ));
      },
      child: CheckboxListTile(
        onChanged: (check) {
          setState(() {
            _todoList[index][ok] = check;
            _saveData();
          });
        },
        value: _todoList[index][ok],
        title: Text(_todoList[index][titulo]),
        secondary: CircleAvatar(
          child: Icon(_todoList[index][ok] ? Icons.check : Icons.error),
        ),
      ),
    );
  }
}
