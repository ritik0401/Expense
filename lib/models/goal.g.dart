// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class Goal extends $Goal with RealmEntity, RealmObjectBase, RealmObject {
  Goal(
    String name,
    int colorValue,
    double amount,
    double savedTot,
  ) {
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'colorValue', colorValue);
    RealmObjectBase.set(this, 'amount', amount);
    RealmObjectBase.set(this, 'savedTot', savedTot);
  }

  Goal._();

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;
  @override
  set name(String value) => throw RealmUnsupportedSetError();

  @override
  int get colorValue => RealmObjectBase.get<int>(this, 'colorValue') as int;
  @override
  set colorValue(int value) => throw RealmUnsupportedSetError();

  @override
  double get amount => RealmObjectBase.get<double>(this, 'amount') as double;
  @override
  set amount(double value) => throw RealmUnsupportedSetError();

  @override
  double get savedTot =>
      RealmObjectBase.get<double>(this, 'savedTot') as double;
  @override
  set savedTot(double value) => throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<Goal>> get changes =>
      RealmObjectBase.getChanges<Goal>(this);

  @override
  Goal freeze() => RealmObjectBase.freezeObject<Goal>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(Goal._);
    return const SchemaObject(ObjectType.realmObject, Goal, 'Goal', [
      SchemaProperty('name', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('colorValue', RealmPropertyType.int),
      SchemaProperty('amount', RealmPropertyType.double),
      SchemaProperty('savedTot', RealmPropertyType.double),
    ]);
  }
}
