// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../types/widgets.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Color pickerColor = Color.fromARGB(255, 196, 167, 211);
  Color currentColor = Color.fromARGB(255, 204, 164, 224);

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void createCategory() {
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(),
          middle: Text("Categories",
              style: TextStyle(color: Colors.black, fontSize: 25)),
          backgroundColor: Colors.blueGrey,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          color: Colors.blueGrey,
          child: Column(children: [
            Expanded(
                child: CupertinoFormSection.insetGrouped(children: [
              ...List.generate(
                  10,
                  (index) => GestureDetector(
                          child: DecoratedBox(
                        decoration: const BoxDecoration(),
                        child: CupertinoFormRow(
                            prefix: Row(children: [
                              Container(
                                  width: 15,
                                  height: 15,
                                  margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  decoration: BoxDecoration(
                                    color: pickerColor,
                                    shape: BoxShape.circle,
                                  )),
                              const Text("Category name"),
                            ]),
                            helper: null,
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                            child: Container()),
                      )))
            ])),
            SafeArea(
                bottom: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Pick a category color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: changeColor,
                                ),
                              ),
                              actions: <Widget>[
                                CupertinoButton(
                                  child: const Text('Got it'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                            // Bottom dot
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: pickerColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                            )),
                      ),
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: CupertinoTextField(
                                placeholder: "Category name",
                                controller: _textController,
                              ))),
                      CupertinoButton(
                        onPressed: createCategory,
                        child: const Icon(CupertinoIcons.paperplane_fill),
                      )
                    ],
                  ),
                ))
          ]),
        ));
  }
}
