import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  State<Todo> createState() => _TodolistState();
}

class _TodolistState extends State<Todo> {
  TextEditingController _textFieldController = TextEditingController();

  String newWork = "";
  bool value = false;
//  static int _len = 10;
  List<bool>? isChecked;
  //List<MyClass>? selecteditems;
  // final List<Todo> _todos = <Todo>[];
  List<String> todoListItem = [];

  var key;
  @override
  initState() {
    super.initState();
    isChecked = List<bool>.filled(todoListItem.length, false, growable: true);
    retrieveStringListValue();
    // Add listeners to this class
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          /* */ foregroundColor: Colors.blue,
          backgroundColor: Colors.black,
          title: const Text('TODO APP'),
          titleSpacing: 0,
/**/ actions: const <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 150.0),
              child: Icon(Icons.delete, color: Colors.red),
            ),
          ],
          elevation: 30.0,
          shadowColor: Colors.green,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
/**/ side: BorderSide(width: 2)),
          leading: IconButton(
            onPressed: () {
              deleteFunction();
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(20),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'Work',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(isCheckedFunction(isChecked!),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
              ]),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1.0, vertical: 1.0),
                    )
                  ]),
              const Divider(
                height: 0,
                color: Colors.black,
                thickness: 1.5,
                indent: 0,
                endIndent: 0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: ListView.builder(
                    itemCount: todoListItem.length,
                    itemBuilder: (context, index) => Row(children: [
                          Checkbox(
                              hoverColor: Colors.black,
                              fillColor: MaterialStateProperty.all(
                                  Color.fromARGB(255, 75, 64, 64)),
                              value: isChecked?[index],
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked![index] = value!;
                                });
                              }),
                          Text(
                            todoListItem[index],
                            style: TextStyle(
                                decoration: isChecked![index]
                                    ? TextDecoration.lineThrough
                                    : null),
                          )
                        ])),
              ),
            ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
              side: BorderSide(width: 2)),
          child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                final value = await showDialog(
                    context: context,
                    builder: (BuildContext cont) {
                      return AlertDialog(
                        contentPadding: EdgeInsets.all(50),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black),
                            borderRadius:
                                BorderRadius.all(Radius.circular(13))),

                        content: TextFormField(
                          //     autofocus: true,
                          controller: _textFieldController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(9))),
                            labelText: 'Enter Your work here',
                          ),
                        ),
                        // actionsPadding: EdgeInsets.only(top: 45),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                child: FlatButton(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        backgroundColor: Colors.white,
                                        color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              SizedBox(
                                child: ElevatedButton(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    newWork = _textFieldController.text;
                                    Navigator.pop(cont, newWork);
                                    isChecked!.add(false);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    });
                if (value != null && !value.isEmpty) {
                  saveStringListValue();

                  print("");
                  //print(todoListItem);
                  setState(() {
                    todoListItem.insert(todoListItem.length, value);
                  });
                  print(todoListItem);
                  _textFieldController.clear();
                }
              },
              child: const Icon(Icons.add, color: Colors.black)),
        ));
  }

  isCheckedFunction(List isChecked) {
    print(isChecked);
    int count = 0;
    for (int i = 0; i < isChecked.length; i++) {
      if (isChecked[i] == false) {
        count++;
      }
    }
    setState(() {
      // var values;
      // values[key] = values;
      // selecteditems?.clear();
      // values.forEach((key, value) {
      //   print('${key}: ${value}');
      //   if (value) {
      //     selecteditems?.add(MyClass(key, value));
    });

    return count.toString();
  }

  saveStringListValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  works.addAll(prefs.getStringList("TodoList")!);
    prefs.setStringList("TodoList", todoListItem);
  }

  retrieveStringListValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("TodoList") != null) {
      todoListItem.addAll(prefs.getStringList("TodoList")!);
      isChecked = List<bool>.filled(todoListItem.length, false, growable: true);
    }
    setState(() {});
  }

  deleteFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("TodoList");
  }
}

/*class MyClass {
  late List<MyClass> selecteditems;
  String title;
  bool value;
  MyClass(this.title, this.value);

  @override
  String toString() {
    return 'MyClass{title: $title, value: $value}';
  }
}*/
