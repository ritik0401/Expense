import '../types/recurrence.dart';
import 'package:realm/realm.dart';

import 'package:intl/intl.dart';

import 'goal.dart';

part 'input_goal.g.dart';

@RealmModel()
class $InputGoal {
  @PrimaryKey()
  late final ObjectId id;
  late final double amount;
  late final $Goal? goal;
  late final DateTime date;
  late final String? note;
  late final String? recurrence = Recurrence.none;

  get dayInWeek {
    DateFormat format = DateFormat("EEEE");
    return format.format(date);
  }

  get dayInMonth {
    return date.day;
  }

  get month {
    DateFormat format = DateFormat("MMM");
    return format.format(date);
  }

  get year {
    return date.year;
  }
}
