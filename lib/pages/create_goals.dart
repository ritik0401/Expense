// ignore_for_file: library_private_types_in_public_api
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

import '../models/goal.dart';
import '../realm.dart';
import '../utils/destructive_prompt.dart';

class GoalsCreate extends StatefulWidget {
  const GoalsCreate({super.key});
  @override
  _GoalsCreateState createState() => _GoalsCreateState();
}

class _GoalsCreateState extends State<GoalsCreate> {
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = Color.fromARGB(255, 188, 177, 194);
  List<Goal> goals = [];

  late TextEditingController _textController;
  late TextEditingController _amountController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: '');
    _amountController = TextEditingController();

    goals = realm.all<Goal>().toList();
  }

  @override
  void dispose() {
    _textController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void createGoal() {
    var newGoal = realm.write<Goal>(() => realm.add(Goal(
        _textController.text,
        pickerColor.value,
        double.parse(_amountController.value.text),
        double.parse(_amountController.value.text))));
    setState(() => goals.add(newGoal));
    _textController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
              onPressed: () => Navigator.pop(context)),
          middle: const Text("Goals",
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
          color: Color.fromARGB(255, 255, 255, 255),
          child: Column(children: [
            goals.isNotEmpty
                ? Expanded(
                    child: CupertinoFormSection.insetGrouped(children: [
                      ...List.generate(
                        goals.length,
                        (index) => GestureDetector(
                          child: DecoratedBox(
                            decoration: const BoxDecoration(),
                            child: Dismissible(
                              key: Key(goals[index].name),
                              confirmDismiss: (_) {
                                var confirmer = Completer<bool>();
                                showAlertDialog(
                                  context,
                                  () {
                                    confirmer.complete(true);
                                  },
                                  "Are you sure?",
                                  "This action cannot be undone.",
                                  "Delete ${goals[index].name} category",
                                  cancellationCallback: () {
                                    confirmer.complete(false);
                                  },
                                );

                                return confirmer.future;
                              },
                              onDismissed: (_) {
                                setState(() {
                                  realm.write(() => realm.delete(goals[index]));
                                  goals.removeAt(index);
                                });
                              },
                              background: Container(
                                color: CupertinoColors.destructiveRed,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16),
                                child: const Icon(
                                  CupertinoIcons.delete,
                                  color: CupertinoColors.white,
                                ),
                              ),
                              child: CupertinoFormRow(
                                  prefix: Row(children: [
                                    Container(
                                        width: 12,
                                        height: 12,
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 0, 8, 0),
                                        decoration: BoxDecoration(
                                          color: goals[index].color,
                                          shape: BoxShape.circle,
                                        )),
                                    Text("Name: ${goals[index].name} "),
                                    Text("Total: ${goals[index].amount} "),
                                    Text("Left: ${goals[index].savedTot}"),
                                  ]),
                                  helper: null,
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 14, 16, 14),
                                  child: Container()),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  )
                : Expanded(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: const Text("No Goals yet",
                          style:
                              TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                    ),
                  ),
            SafeArea(
                bottom: true,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: const Text('Pick a category color'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  color: pickerColor,
                                  onColorChanged: changeColor,
                                  heading: const Text('Select color'),
                                  subheading: const Text('Select color shade'),
                                  wheelSubheading: const Text(
                                      'Selected color and its shades'),
                                  pickersEnabled: const <ColorPickerType, bool>{
                                    ColorPickerType.primary: true,
                                    ColorPickerType.accent: true,
                                    ColorPickerType.custom: true,
                                    ColorPickerType.wheel: true,
                                  },
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
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: pickerColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  width: 2),
                            )),
                      ),
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: CupertinoTextField(
                                placeholder: "Goal name",
                                controller: _textController,
                              ))),
                      Expanded(
                          child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              child: CupertinoTextField(
                                placeholder: "Goal Total",
                                controller: _amountController,
                              ))),
                      CupertinoButton(
                        onPressed: createGoal,
                        child: const Icon(CupertinoIcons.paperplane_fill),
                      )
                    ],
                  ),
                ))
          ]),
        ));
  }
}
