// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_goal.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class InputGoal extends $InputGoal
    with RealmEntity, RealmObjectBase, RealmObject {
  static var _defaultsSet = false;

  InputGoal(
    ObjectId id,
    double amount,
    DateTime date, {
    Goal? goal,
    String? note,
    String? recurrence = Recurrence.none,
  }) {
    if (!_defaultsSet) {
      _defaultsSet = RealmObjectBase.setDefaults<InputGoal>({
        'recurrence': Recurrence.none,
      });
    }
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'goal', goal);
    RealmObjectBase.set(this, 'date', date);
    RealmObjectBase.set(this, 'note', note);
    RealmObjectBase.set(this, 'recurrence', recurrence);
  }

  InputGoal._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, 'id') as ObjectId;
  @override
  set id(ObjectId value) => throw RealmUnsupportedSetError();

  @override
  double get amount => RealmObjectBase.get<double>(this, 'amount') as double;
  @override
  set amount(double value) => throw RealmUnsupportedSetError();

  @override
  Goal? get goal => RealmObjectBase.get<Goal>(this, 'goal') as Goal?;
  @override
  set goal(covariant Goal? value) => throw RealmUnsupportedSetError();

  @override
  DateTime get date => RealmObjectBase.get<DateTime>(this, 'date') as DateTime;
  @override
  set date(DateTime value) => throw RealmUnsupportedSetError();

  @override
  String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
  @override
  set note(String? value) => throw RealmUnsupportedSetError();

  @override
  String? get recurrence =>
      RealmObjectBase.get<String>(this, 'recurrence') as String?;
  @override
  set recurrence(String? value) => throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<InputGoal>> get changes =>
      RealmObjectBase.getChanges<InputGoal>(this);

  @override
  InputGoal freeze() => RealmObjectBase.freezeObject<InputGoal>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(InputGoal._);
    return const SchemaObject(ObjectType.realmObject, InputGoal, 'InputGoal', [
      SchemaProperty('id', RealmPropertyType.objectid, primaryKey: true),
      SchemaProperty('amount', RealmPropertyType.double),
      SchemaProperty('goal', RealmPropertyType.object,
          optional: true, linkTarget: 'Goal'),
      SchemaProperty('date', RealmPropertyType.timestamp),
      SchemaProperty('note', RealmPropertyType.string, optional: true),
      SchemaProperty('recurrence', RealmPropertyType.string, optional: true),
    ]);
  }
}
