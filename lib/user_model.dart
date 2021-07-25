import 'package:flutter/foundation.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class UserModel extends ChangeNotifier{
  static ParseUser? _user;

  static ParseUser? get user => _user;
  static set user(ParseUser? user) => _user = user;
}