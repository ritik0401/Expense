// ignore_for_file: library_private_types_in_public_api
import 'dart:async';

import 'package:flutter/cupertino.dart';
import '../constants.dart';
import '../models/goal.dart';
import '../models/input_goal.dart';
import '../realm.dart';
import '../types/recurrence.dart';
import '../types/widgets.dart';
import '../utils/picker_utils.dart';
import 'package:realm/realm.dart';

var recurrences = List.from(Recurrence.values);

class AddGoals extends WidgetWithTitle {
  const AddGoals({super.key}) : super(title: "Add");

  @override
  Widget build(BuildContext context) {
    return const AddGoalsContent();
  }
}

class AddGoalsContent extends StatefulWidget {
  const AddGoalsContent({super.key});

  @override
  _AddGoalsContent createState() => _AddGoalsContent();
}

class _AddGoalsContent extends State<AddGoalsContent> {
  late TextEditingController _amountController;
  late TextEditingController _noteController;

  var realmGoals = realm.all<Goal>();

  StreamSubscription<RealmResultsChanges<Goal>>? _goalSub;

  List<Goal> goals = [];
  int _selectedRecurrenceIndex = 0;
  int _selectedGoalIndex = 0;
  DateTime _selectedDate = DateTime.now();
  bool canSubmit = false;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController();
    _noteController = TextEditingController();
    goals = realmGoals.toList();
    canSubmit = goals.isNotEmpty && _amountController.text.isNotEmpty;
  }

  @override
  Future<void> dispose() async {
    await _goalSub?.cancel();
    super.dispose();
  }

  void submitGoal() {
    realm.write(() => realm.add<InputGoal>(InputGoal(
          ObjectId(),
          double.parse(_amountController.value.text),
          _selectedDate,
          goal: goals[_selectedGoalIndex],
          note: _noteController.value.text.isNotEmpty
              ? _noteController.value.text
              : goals[_selectedGoalIndex].name,
          recurrence: recurrences[_selectedRecurrenceIndex],
        )));
    final id = goals[_selectedGoalIndex].name;
    final same = goals[_selectedGoalIndex].colorValue;
    final total = goals[_selectedGoalIndex].amount;
    final left = goals[_selectedGoalIndex].savedTot -
        double.parse(_amountController.value.text);

    var newGoal = Goal(id, same, total, left);

    setState(() {
      realm.write(() => realm.add<Goal>(newGoal, update: true));
      _amountController.clear();
      _selectedRecurrenceIndex = 0;
      _selectedDate = DateTime.now();
      _noteController.clear();
      _selectedGoalIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    _goalSub ??= realmGoals.changes.listen((event) {
      goals = event.results.toList();
    });

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        middle: Text("Contribute Towards Goal"),
      ),
      child: SafeArea(
        left: true,
        top: true,
        right: true,
        bottom: true,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          transformAlignment: Alignment.center,
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: DecoratedBox(
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  CupertinoFormSection.insetGrouped(children: [
                    DecoratedBox(
                      decoration: const BoxDecoration(),
                      child: CupertinoFormRow(
                        prefix: const Text("Amount",
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                        helper: null,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: CupertinoTextField.borderless(
                          placeholder: "Amount",
                          controller: _amountController,
                          onChanged: (value) {
                            setState(() => canSubmit =
                                goals.isNotEmpty && value.isNotEmpty);
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          textAlign: TextAlign.end,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            backgroundColor: Color.fromARGB(0, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(),
                      child: CupertinoFormRow(
                        prefix: const Text("Recurrence",
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                        helper: null,
                        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                        child: CupertinoButton(
                          onPressed: () => showPicker(
                            context,
                            CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                initialItem: _selectedRecurrenceIndex,
                              ),
                              magnification: 1,
                              squeeze: 1.2,
                              useMagnifier: false,
                              itemExtent: kItemExtent,
                              // This is called when selected item is changed.
                              onSelectedItemChanged: (int selectedItem) {
                                setState(() {
                                  _selectedRecurrenceIndex = selectedItem;
                                });
                              },
                              children: List<Widget>.generate(
                                  recurrences.length, (int index) {
                                return Center(
                                  child: Text(recurrences[index]),
                                );
                              }),
                            ),
                          ),
                          child: Text(recurrences[_selectedRecurrenceIndex]),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(),
                      child: CupertinoFormRow(
                        prefix: const Text("Date",
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                        helper: null,
                        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                        child: CupertinoButton(
                          onPressed: () => showPicker(
                            context,
                            CupertinoDatePicker(
                              initialDateTime: _selectedDate,
                              mode: CupertinoDatePickerMode.dateAndTime,
                              use24hFormat: true,
                              // This is called when the user changes the time.
                              onDateTimeChanged: (DateTime newTime) {
                                setState(() => _selectedDate = newTime);
                              },
                            ),
                          ),
                          child: Text(
                              '${_selectedDate.month}/${_selectedDate.day}/${_selectedDate.year} ${_selectedDate.hour}:${_selectedDate.minute}'),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(),
                      child: CupertinoFormRow(
                        prefix: const Text("Note",
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                        helper: null,
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: CupertinoTextField.borderless(
                          placeholder: "Note",
                          controller: _noteController,
                          textAlign: TextAlign.end,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            backgroundColor: Color.fromARGB(0, 0, 0, 0),
                          ),
                        ),
                      ),
                    ),
                    DecoratedBox(
                      decoration: const BoxDecoration(),
                      child: CupertinoFormRow(
                        prefix: const Text("Goal",
                            style:
                                TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
                        helper: null,
                        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
                        child: CupertinoButton(
                          onPressed: () => showPicker(
                            context,
                            CupertinoPicker(
                              scrollController: FixedExtentScrollController(
                                  initialItem: _selectedGoalIndex),
                              magnification: 1,
                              squeeze: 1.2,
                              useMagnifier: false,
                              itemExtent: kItemExtent,
                              // This is called when selected item is changed.
                              onSelectedItemChanged: (int selectedItem) {
                                setState(() {
                                  _selectedGoalIndex = selectedItem;
                                });
                              },
                              children: List<Widget>.generate(goals.length,
                                  (int index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 64),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: 12,
                                          height: 12,
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 8, 0),
                                          decoration: BoxDecoration(
                                            color: goals[index].color,
                                            shape: BoxShape.circle,
                                          )),
                                      Text(goals[index].name),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          child: Text(
                            goals.isEmpty
                                ? "Create a category first"
                                : goals[_selectedGoalIndex].name,
                            style: TextStyle(
                              color: goals.isEmpty
                                  ? const Color.fromARGB(255, 0, 0, 0)
                                  : goals[_selectedGoalIndex].color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Container(
                    margin: const EdgeInsets.only(top: 32),
                    child: CupertinoButton(
                      onPressed: canSubmit ? submitGoal : null,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 13),
                      color: CupertinoTheme.of(context).primaryColor,
                      disabledColor: CupertinoTheme.of(context)
                          .primaryColor
                          .withAlpha(100),
                      borderRadius: BorderRadius.circular(10),
                      pressedOpacity: 0.7,
                      child: Text(
                        "Submit Contribution",
                        style: TextStyle(
                          color: canSubmit
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(100, 255, 255, 255),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
