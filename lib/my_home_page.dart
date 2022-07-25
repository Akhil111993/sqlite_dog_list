import 'package:flutter/material.dart';

import 'database_functions.dart';
import 'dog_model.dart';

class MyHomePage extends StatefulWidget {
  final database;
  const MyHomePage({Key? key, this.database}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int id = 0;
  String name = '';
  int age = 35;
  List<Dog> dogList = [];
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fillDetails(true);
  }

  fillDetails(bool isDogs) async {
    dogList = isDogs
        ? await DatabaseFunctions().dogs(widget.database)
        : await DatabaseFunctions().dogsOfAge14(widget.database);
    setState(() {
      id = dogList.length;
    });
  }

  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 60,
      duration: const Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Dog name'),
            ),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'age - integer only'),
            ),
            ElevatedButton(
              onPressed: () async {
                var fido = Dog(
                  id: id,
                  name: _nameController.text,
                  age: int.parse(_ageController.text),
                );

                await DatabaseFunctions().insertDog(fido, widget.database);
                fillDetails(true);
                _scrollDown();
                _nameController.clear();
                _ageController.clear();
              },
              child: const Text('Save'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    fillDetails(false);
                  },
                  child: const Text('Get dogs of age 14'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    fillDetails(true);
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (_, index) => ListTile(
                  title: Text(dogList[index].name),
                  subtitle: Text(
                    dogList[index].age.toString(),
                  ),
                  leading: Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: 30,
                    child: Text(
                      dogList[index].id.toString(),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                itemCount: dogList.length,
                controller: _scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
