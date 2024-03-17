import 'package:realm/realm.dart';

import 'models/expense.dart';
import 'models/category.dart';
import 'models/goal.dart';
import 'models/input_goal.dart';

var _config = Configuration.local(
    [Expense.schema, Category.schema, Goal.schema, InputGoal.schema]);
var realm = Realm(_config);
