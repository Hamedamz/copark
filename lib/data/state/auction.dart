import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class AuctionModel extends ChangeNotifier {
  var _isStarted = true;
  var _isUserParticipated = false;
  var _daysToStart = 20;
  var _bid = 1000;

  bool get isStarted => _isStarted;

  set isStarted(bool isStarted) {
    _isStarted = isStarted;
    notifyListeners();
  }

  bool get isUserParticipated => _isUserParticipated;

  set isUserParticipated(bool isUserParticipated) {
    _isUserParticipated = isUserParticipated;
    notifyListeners();
  }

  int get bid => _bid;

  set bid(int bid) {
    _bid = bid;
    notifyListeners();
  }
}