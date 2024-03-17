// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:collection/collection.dart';

import '../components/expenses_list.dart';
import '../extensions/number_extensions.dart';
import '../extensions/expenses_extensions.dart';
import '../constants.dart';
import '../models/expense.dart';
import '../models/goal.dart';
import '../realm.dart';
import '../types/period.dart';
import '../types/widgets.dart';
import '../utils/destructive_prompt.dart';
import '../utils/picker_utils.dart';
import 'package:realm/realm.dart';

class Expenses extends WidgetWithTitle {
  const Expenses({super.key}) : super(title: "Expenses");

  @override
  Widget build(BuildContext context) {
    return const ExpensesContent();
  }
}

class ExpensesContent extends StatefulWidget {
  const ExpensesContent({super.key});

  @override
  _ExpensesContent createState() => _ExpensesContent();
}

class _ExpensesContent extends State<ExpensesContent> {
  int _selectedPeriodIndex = 1;
  Period get _selectedPeriod => periods[_selectedPeriodIndex];

  var realmExpenses = realm.all<Expense>();
  StreamSubscription<RealmResultsChanges<Expense>>? _expensesSub;
  List<Expense> _expenses = [];

  var realmGoals = realm.all<Goal>();
  StreamSubscription<RealmResultsChanges<Goal>>? _goalsSub;
  List<Goal> _goals = [];

  double get _total => _expenses.map((expense) => expense.amount).sum;

  @override
  void initState() {
    super.initState();
    _expenses = realmExpenses.toList().filterByPeriod(_selectedPeriod, 0)[0];
    _goals = realmGoals.toList();
  }

  @override
  Future<void> dispose() async {
    await _expensesSub?.cancel();
    await _goalsSub?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _expensesSub ??= realmExpenses.changes.listen((changes) {
      setState(() {
        _expenses =
            changes.results.toList().filterByPeriod(_selectedPeriod, 0)[0];
      });
    });

    _goalsSub ??= realmGoals.changes.listen((changes2) {
      setState(() {
        _goals = changes2.results.toList();
      });
    });

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        middle: Text("Expenses"),
      ),
      child: SafeArea(
        left: true,
        top: true,
        right: true,
        bottom: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Total for: "),
                CupertinoButton(
                  onPressed: () => showPicker(
                    context,
                    CupertinoPicker(
                      scrollController: FixedExtentScrollController(
                          initialItem: _selectedPeriodIndex),
                      magnification: 1,
                      squeeze: 1.2,
                      useMagnifier: false,
                      itemExtent: kItemExtent,
                      // This is called when selected item is changed.
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          _selectedPeriodIndex = selectedItem;
                          _expenses = realmExpenses.toList().filterByPeriod(
                              periods[_selectedPeriodIndex], 0)[0];
                        });
                      },
                      children:
                          List<Widget>.generate(periods.length, (int index) {
                        return Center(
                          child: Text(getPeriodDisplayName(periods[index])),
                        );
                      }),
                    ),
                  ),
                  child: Text(getPeriodDisplayName(_selectedPeriod)),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 4, 4, 0),
                  child: const Text("\$",
                      style: TextStyle(
                        fontSize: 20,
                        color: CupertinoColors.inactiveGray,
                      )),
                ),
                Text(_total.removeDecimalZeroFormat(),
                    style: const TextStyle(
                      fontSize: 40,
                    )),
              ],
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 16, 12, 0),
                child: ExpensesList(expenses: _expenses),
              ),
            ),
            Expanded(
              child: Column(children: [
                _goals.isNotEmpty
                    ? Expanded(
                        child: CupertinoFormSection.insetGrouped(children: [
                          ...List.generate(
                            _goals.length,
                            (index) => GestureDetector(
                              child: DecoratedBox(
                                decoration: const BoxDecoration(),
                                child: Dismissible(
                                  key: Key(_goals[index].name),
                                  confirmDismiss: (_) {
                                    var confirmer = Completer<bool>();
                                    showAlertDialog(
                                      context,
                                      () {
                                        confirmer.complete(true);
                                      },
                                      "Are you sure?",
                                      "This action cannot be undone.",
                                      "Delete ${_goals[index].name} category",
                                      cancellationCallback: () {
                                        confirmer.complete(false);
                                      },
                                    );

                                    return confirmer.future;
                                  },
                                  onDismissed: (_) {
                                    setState(() {
                                      realm.write(
                                          () => realm.delete(_goals[index]));
                                      _goals.removeAt(index);
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
                                              color: _goals[index].color,
                                              shape: BoxShape.circle,
                                            )),
                                        Text("Name: ${_goals[index].name} "),
                                        Text("Total: ${_goals[index].amount} "),
                                        Text("Left: ${_goals[index].savedTot}"),
                                      ]),
                                      helper: null,
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 14, 16, 14),
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
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0))),
                        ),
                      ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
