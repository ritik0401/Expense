import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/categories.dart';
import '../types/widgets.dart';

class Item {
  final String label;
  final bool isDestructive;

  const Item(this.label, this.isDestructive);
}

const items = [
  Item('Categories', false),
  Item('Erase all data', true),
];

class Settings extends WidgetWithTitle {
  const Settings({super.key}) : super(title: "Settings");

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color.fromARGB(0, 10, 0, 0),
        middle: Text("Settings"),
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
          child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 28, 28, 30),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CupertinoFormSection.insetGrouped(children: [
                ...List.generate(
                    items.length,
                    (index) => GestureDetector(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const Categories()));
                              break;
                            case 1:
                              /* showAlertDialog(
                                context,
                                () {
                                  realm.write(() {
                                    realm.deleteAll<Expense>();
                                    realm.deleteAll<Category>();
                                  });
                                },
                                "Are you sure?",
                                "This action cannot be undone.",
                                "Erase data",
                              ); */
                              break;
                          }
                        },
                        child: DecoratedBox(
                          decoration: const BoxDecoration(),
                          child: CupertinoFormRow(
                            prefix: Text(items[index].label,
                                style: TextStyle(
                                    color: items[index].isDestructive
                                        ? const Color.fromARGB(255, 255, 69, 58)
                                        : const Color.fromARGB(255, 0, 0, 0))),
                            helper: null,
                            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                            child: items[index].isDestructive
                                ? Container()
                                : const Icon(
                                    Icons.add_box_rounded,
                                    size: 50,
                                  ),
                          ),
                        )))
              ])),
        ),
      ),
    );
  }
}
