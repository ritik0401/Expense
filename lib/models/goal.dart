import 'package:realm/realm.dart';
import 'dart:ui';

part 'goal.g.dart';

@RealmModel()
class $Goal {
  @PrimaryKey()
  late final String name;
  late final int colorValue;
  late final double amount;
  late final double savedTot;

  Color get color {
    return Color(colorValue);
  }

  double get total {
    return amount;
  }

  double get saved {
    return savedTot;
  }

  set color(Color value) {
    colorValue = value.value;
  }
}
