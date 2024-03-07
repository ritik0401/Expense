import 'package:flutter/material.dart';
import '../types/widgets.dart';

class Goals extends WidgetWithTitle {
  const Goals({super.key}) : super(title: "Goals");

  @override
  Widget build(BuildContext context) {
    return const Text("Goals!");
  }
}
