// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_const_literals_to_create_immutables, unused_import, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class Mywork extends StatefulWidget {
  const Mywork({Key? key}) : super(key: key);
  @override
  State<Mywork> createState() => _MyworkState();
}

class _MyworkState extends State<Mywork> {
  late SharedPreferences prefs;
  final TextEditingController _textEditingController = TextEditingController();
  List<String> works = [];
  List<String> checks = [];
  List<bool>? ischecked;

  savingbool(int index) {
    checks = List<String>.filled(ischecked!.length, 'F', growable: true);
    checks[index] = 'T';
  }

  retrieveBool() async {
    print('retrieve bool');
    ischecked = List<bool>.filled(works.length, false, growable: true);
    // checks = List<String>.filled(ischecked!.length, 'B');
    print('retrieve bool');
    prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("checksList") != null) {
      checks.addAll(prefs.getStringList("checksList")!);
    }

    if (ischecked != null && checks.isNotEmpty) {
      for (int j = 0; j < ischecked!.length; j++) {
        print(checks);
        if (checks[j] == 'T') {
          // print('retrieve bool');
          ischecked!.add(true);
        } else {
          ischecked!.add(false);
        }
        print(checks[j]);
      }
    }

    setState(() {});
  }

  savechecks() async {
    print('save checks');
    print(checks);
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("checksList", checks);
  }

  saveStringListValue() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("TodoList", works);
  }

  retrieveStringListValue() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("TodoList") != null) {
      works.addAll(prefs.getStringList("TodoList")!);
      ischecked = List<bool>.filled(works.length, false, growable: true);
    }
    setState(() {});
  }

  deleteValue() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove("TodoList");
    prefs.remove('checksList');
  }

  ischeckedfunction(List ischecked) {
    int count = 0;
    for (int i = 0; i < ischecked.length; i++) {
      if (ischecked[i] == false) {
        count++;
      }
    }
    return count.toString();
  }

  @override
  void initState() {
    retrieveStringListValue();
    retrieveBool();
    super.initState();
    ischecked = List<bool>.filled(works.length, false, growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('TODO APP'),
          leading: IconButton(
            onPressed: () {
              deleteValue();
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'Work',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(ischeckedfunction(ischecked!),
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: ListView.builder(
                    itemCount: works.length,
                    itemBuilder: ((context, index) => CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.black,
                        value: ischecked?[index],
                        onChanged: (bool? value) {
                          setState(() {
                            ischecked?[index] = value!;
                          });
                          savingbool(index);
                          savechecks();
                        },
                        title: Text(
                          works[index],
                          style: TextStyle(
                              decoration: ischecked![index]
                                  ? TextDecoration.lineThrough
                                  : null),
                        )))),
              )
            ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
              side: BorderSide(width: 2)),
          child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                final myWork = await showDialog(
                    context: context,
                    builder: (BuildContext cont) => AlertDialog(
                          content: TextFormField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Enter Your work here',
                            ),
                          ),
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
                                      Navigator.pop(cont);
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
                                      Navigator.pop(
                                          cont, _textEditingController.text);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ));
                if (myWork != null && !myWork.isEmpty) {
                  setState(() {
                    ischecked!.add(false);
                    works.add(_textEditingController.text);
                    saveStringListValue();
                    _textEditingController.clear();
                  });
                }
              },
              child: const Icon(Icons.add, color: Colors.black)),
        ));
  }
}




//import 'dart:ui';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// class Todo extends StatefulWidget {
//   const Todo({Key? key}) : super(key: key);

//   @override
//   State<Todo> createState() => _TodolistState();
// }

// class _TodolistState extends State<Todo> {
//   late SharedPreferences prefs;
//   TextEditingController _textFieldController = TextEditingController();
//   String newWork = "";

//   List<String> checks = [];

//   bool value = false;
// //  static int _len = 10;
//   List<bool>? isChecked;

//   // final List<Todo> _todos = <Todo>[];
//   List<String> todoListItem = [];
//   @override
//   initState() {
//     super.initState();
//     isChecked = List<bool>.filled(todoListItem.length, false, growable: true);
//     retrieveStringListValue();
//     retrieveBool();
//     checkFunction();
//     // Add listeners to this class
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: const Text('TODO APP'),
//           titleSpacing: 0,
//           leading: IconButton(
//             onPressed: () {
//               deleteFunction();
//             },
//             icon: Icon(Icons.arrow_back_ios_new),
//           ),
//         ),
//         body: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             margin: EdgeInsets.all(20),
//             child: Column(children: [
//               Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                 Text(
//                   'Work',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
//                 ),
//                 Text(isCheckedFunction(isChecked!),
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
//               ]),
//               const Divider(
//                 height: 0,
//                 color: Colors.black,
//                 thickness: 1.5,
//                 indent: 0,
//                 endIndent: 0,
//               ),
//               SizedBox(
//                 height: MediaQuery.of(context).size.height / 1.3,
//                 child: ListView.builder(
//                     itemCount: todoListItem.length,
//                     itemBuilder: (context, index) => Row(children: [
//                           Checkbox(
//                               hoverColor: Colors.black,
//                               fillColor: MaterialStateProperty.all(
//                                   Color.fromARGB(255, 75, 64, 64)),
//                               value: isChecked?[index],
//                               onChanged: (bool? value) {
//                                 setState(() {
//                                   isChecked![index] = value!;
//                                 });
//                                 savingbool(index);
//                                 savechecks();
//                               }),
//                           Text(
//                             todoListItem[index],
//                             style: TextStyle(
//                                 decoration: isChecked![index]
//                                     ? TextDecoration.lineThrough
//                                     : null),
//                           )
//                         ])),
//               ),
//             ])),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: Material(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(90),
//               side: BorderSide(width: 2)),
//           child: FloatingActionButton(
//               backgroundColor: Colors.white,
//               onPressed: () async {
//                 final value = await showDialog(
//                     context: context,
//                     builder: (BuildContext cont) {
//                       return AlertDialog(
//                         contentPadding: EdgeInsets.all(50),
//                         shape: RoundedRectangleBorder(
//                             side: BorderSide(color: Colors.black),
//                             borderRadius:
//                                 BorderRadius.all(Radius.circular(13))),

//                         content: TextFormField(
//                           controller: _textFieldController,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(9))),
//                             labelText: 'Enter Your work here',
//                           ),
//                         ),
//                         // actionsPadding: EdgeInsets.only(top: 45),
//                         actions: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               SizedBox(
//                                 child: FlatButton(
//                                   child: Text(
//                                     "Cancel",
//                                     style: TextStyle(
//                                         backgroundColor: Colors.white,
//                                         color: Colors.black),
//                                   ),
//                                   onPressed: () {
//                                     Navigator.of(context).pop();
//                                   },
//                                 ),
//                               ),
//                               SizedBox(
//                                 child: ElevatedButton(
//                                   child: Text(
//                                     "Submit",
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   onPressed: () {
//                                     newWork = _textFieldController.text;
//                                     Navigator.pop(cont, newWork);
//                                     isChecked!.add(false);
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       );
//                     });
//                 if (value != null && !value.isEmpty) {
//                   saveStringListValue();

//                   print("");
//                   //print(todoListItem);
//                   setState(() {
//                     todoListItem.insert(todoListItem.length, value);
//                   });
//                   print(todoListItem);
//                   _textFieldController.clear();
//                 }
//               },
//               child: const Icon(Icons.add, color: Colors.black)),
//         ));
//   }

//   isCheckedFunction(List isChecked) {
//     print(isChecked);
//     int count = 0;
//     for (int i = 0; i < isChecked.length; i++) {
//       if (isChecked[i] == false) {
//         count++;
//       }
//     }

//     return count.toString();
//   }

//   saveStringListValue() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     //  works.addAll(prefs.getStringList("TodoList")!);
//     prefs.setStringList("TodoList", todoListItem);
//   }

//   retrieveStringListValue() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (prefs.getStringList("TodoList") != null) {
//       todoListItem.addAll(prefs.getStringList("TodoList")!);
//       isChecked = List<bool>.filled(todoListItem.length, false, growable: true);
//     }
//     setState(() {});
//   }

//   deleteFunction() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.remove("TodoList");
//     prefs.remove("checksList");
//   }

//   checkFunction() async {
//     var checkFunc = List<String>.filled(isChecked!.length, "false");
//     for (int a = 0; a < isChecked!.length; a++) {
//       if (isChecked![a] == true) {}
//     }
//   }

//   savingbool(int index) {
//     checks = List<String>.filled(isChecked!.length, 'F', growable: true);
//     checks[index] = 'T';
//   }

//   retrieveBool() async {
//     print('retrieve bool');
//     isChecked = List<bool>.filled(todoListItem.length, false, growable: true);
//     // checks = List<String>.filled(ischecked!.length, 'B');
//     print('retrieve bool');
//     prefs = await SharedPreferences.getInstance();
//     if (prefs.getStringList("ChecksList") != null) {
//       checks.addAll(prefs.getStringList("ChecksList")!);
//     }
//     if (isChecked != null && todoListItem.isNotEmpty) {
//       for (int j = 0; j < isChecked!.length; j++) {
//         print(checks);
//         if (checks[j] == 'T') {
//           // print('retrieve bool');
//           isChecked!.add(true);
//         } else {
//           isChecked!.add(false);
//         }
//         print(checks[j]);
//       }
//     }

//     setState(() {});
//   }

//   savechecks() async {
//     print('save checks');
//     print(checks);
//     prefs = await SharedPreferences.getInstance();
//     prefs.setStringList("ChecksList", checks);
//   }
// }







/*import 'dart:ui';
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
  List<MyClass>? selecteditems;
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
          backgroundColor: Colors.black,
          title: const Text('TODO APP'),
          titleSpacing: 0,
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
      var values;
      values[key] = values;
      selecteditems?.clear();
      values.forEach((key, value) {
        print('${key}: ${value}');
        if (value) {
          selecteditems?.add(MyClass(key, value));
        }
      });
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

class MyClass {
  late List<MyClass> selecteditems;
  String title;
  bool value;
  MyClass(this.title, this.value);

  @override
  String toString() {
    return 'MyClass{title: $title, value: $value}';
  }
}
*/





class Mywork extends StatefulWidget {
  const Mywork({Key? key}) : super(key: key);
  @override
  State<Mywork> createState() => _MyworkState();
}

class _MyworkState extends State<Mywork> {
  late SharedPreferences prefs;
  final TextEditingController _textEditingController = TextEditingController();
  List<String> works = [];
  List<String> checks = [];
  List<String> checksLoaclList = [];
  List<bool>? ischecked;  

  savingbool(int index, {bool? trueOrFalse}) {
    checksLoaclList.clear();
    print(ischecked);
    // checksLoaclList =
    //     List<String>.filled(ischecked!.length, 'false', growable: true);
    for (int i = 0; i < ischecked!.length; i++) {
      checksLoaclList.insert(i, ischecked![i].toString());
    }
    // checksLoaclList = List<String>.filled(
    //     ischecked!.length, ischecked![index].toString(),
    //     growable: true);
    savechecks();
    // if (trueOrFalse!) {
    //   checksLoaclList[index] = 'True';
    // }

    // print(checks);
    // print("kjfnbhf");
  }

  retrieveBool() async {
    print('retrieve bool');
    ischecked = List<bool>.filled(works.length, false, growable: true);
    // checks = List<String>.filled(ischecked!.length, 'B');
    print('retrieve bool');
    prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("checksList") != null) {
      checks.addAll(prefs.getStringList("checksList")!);
    }

    if (ischecked != null && checks.isNotEmpty) {
      for (int j = 0; j < checks.length; j++) {
        print(checks);
        if (checks[j] == 'true') {
          // print('retrieve bool');
          ischecked!.insert(j, true);
        } else {
          ischecked!.insert(j, false);
        }
        print(checks[j]);
      }
    }

    setState(() {});
  }

  savechecks() async {
    print('save checks');
    print(checksLoaclList);
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("checksList", checksLoaclList);
  }

  saveStringListValue() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("TodoList", works);
  }

  retrieveStringListValue() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("TodoList") != null) {
      works.addAll(prefs.getStringList("TodoList")!);
      ischecked = List<bool>.filled(works.length, false, growable: true);
    }
    setState(() {});
  }

  deleteValue() async {
    prefs = await SharedPreferences.getInstance();
    prefs.remove("TodoList");
    prefs.remove('checksList');
  }

  ischeckedfunction(List ischecked) {
    int count = 0;
    for (int i = 0; i < ischecked.length; i++) {
      if (ischecked[i] == false) {
        count++;
      }
    }
    return count.toString();
  }

  @override
  void initState() {
    retrieveStringListValue();
    retrieveBool();
    super.initState();
    ischecked = List<bool>.filled(works.length, false, growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('TODO APP'),
          leading: IconButton(
            onPressed: () {
              deleteValue();
            },
            icon: Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                  'Work',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(ischeckedfunction(ischecked!),
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
              Divider(
                color: Colors.black,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: ListView.builder(
                    itemCount: works.length,
                    itemBuilder: ((context, index) => CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.black,
                        value: ischecked?[index],
                        onChanged: (bool? value) {
                          setState(() {
                            ischecked?.insert(index, value!);
                          });

                          savingbool(index, trueOrFalse: value);
                        },
                        title: Text(
                          works[index],
                          style: TextStyle(
                              decoration: ischecked![index]
                                  ? TextDecoration.lineThrough
                                  : null),
                        )))),
              )
            ])),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(90),
              side: BorderSide(width: 2)),
          child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () async {
                final myWork = await showDialog(
                    context: context,
                    builder: (BuildContext cont) => AlertDialog(
                          content: TextFormField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Enter Your work here',
                            ),
                          ),
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
                                      Navigator.pop(cont);
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
                                      Navigator.pop(
                                          cont, _textEditingController.text);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ));
                if (myWork != null && !myWork.isEmpty) {
                  setState(() {
                    ischecked!.add(false);
                    works.add(_textEditingController.text);
                    saveStringListValue();
                    _textEditingController.clear();
                  });
                }
              },
              child: const Icon(Icons.add, color: Colors.black)),
        ));
  }
}




changed according to dani


/*import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Todo extends StatefulWidget {
  const Todo({Key? key}) : super(key: key);

  @override
  State<Todo> createState() => _TodolistState();
}

class _TodolistState extends State<Todo> {
  late SharedPreferences prefs;
  TextEditingController _textFieldController = TextEditingController();
  String newWork = "";

  List<String> checks = [];
   List<String> checksLocalList = [];

  bool value = false;
//  static int _len = 10;
  List<bool>? isChecked;

  // final List<Todo> _todos = <Todo>[];
  List<String> todoListItem = [];
  @override
  void initState() {
    super.initState();
    isChecked = List<bool>.filled(todoListItem.length, false, growable: true);
    retrieveStringListValue();
    retrieveBool();
    //  checkFunction();
    // Add listeners to this class
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('TODO APP'),
          titleSpacing: 0,
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
                                savingbool(index, trueOrFalse: value);
                                savechecks();
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
                    isChecked!.add(false);
                    todoListItem.add(newWork);
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
    prefs.remove("checksList");
  }

  checkFunction() async {
    var checkFunc = List<String>.filled(isChecked!.length, "false");
    for (int a = 0; a < isChecked!.length; a++) {
      if (isChecked![a] == true) {}
    }
  }

  savingbool(int index, {bool? trueOrFalse}) {
    checksLocalList.clear();
    print(isChecked);
    
    for (int i = 0; i < isChecked!.length; i++) {
      checksLocalList.insert(i, isChecked![i].toString());
    }
    
    savechecks();
    // checks = List<String>.filled(isChecked!.length, 'F', growable: true);
    // checks[index] = 'T';
  }

  retrieveBool() async {
    print('retrieve bool');
    isChecked = List<bool>.filled(todoListItem.length, false, growable: true);
    // checks = List<String>.filled(ischecked!.length, 'B');
    print('retrieve bool');
    prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("checksList") != null) {
      checks.addAll(prefs.getStringList("checksList")!);
    }
    if (isChecked != null && checks.isNotEmpty) {
      for (int j = 0; j < checks.length; j++) {
        print(checks);
        if (checks[j] == 'T') {
          // print('retrieve bool');
          isChecked!.add(true);
        } else {
          isChecked!.add(false);
        }
        print(checks[j]);
      }
    }

    setState(() {});
  }

  savechecks() async {
    print('save checks');
    print(checksLocalList);
    prefs = await SharedPreferences.getInstance();
    prefs.setStringList("checksList", checksLocalList);
  }
}
*/