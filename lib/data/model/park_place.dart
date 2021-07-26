import 'dart:core';

import 'package:parse_server_sdk/parse_server_sdk.dart';

const String keyParkPlace = 'ParkPlace';
const String keyNumber = 'number';
const String keyOwner = 'owner';
const String keyActive = 'isActive';

class ParkPlace extends ParseObject implements ParseCloneable {
  ParkPlace() : super(keyParkPlace);

  ParkPlace.clone() : this();

  @override
  ParkPlace clone(Map<String, dynamic> map) => ParkPlace.clone()..fromJson(map);

  num get number => get<num>(keyNumber)!;
  set number(num number) => set<num>(keyNumber, number);

  ParseUser get owner => get<ParseUser>(keyOwner)!;
  set owner(ParseUser owner) => set<ParseUser>(keyOwner, owner);

  bool get isActive => get<bool>(keyActive)!;
  set isActive(bool isActive) => set<bool>(keyActive, isActive);
}
