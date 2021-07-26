import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/settings.dart';

abstract class SettingsContract {
  Future<ApiResponse> get();

  Future<ApiResponse> update(Settings item);
}