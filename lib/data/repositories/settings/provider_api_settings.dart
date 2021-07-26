import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/settings.dart';

import 'package:parse_server_sdk/parse_server_sdk.dart';

import 'contract_settings.dart';

class SettingsProviderApi implements SettingsContract {
  SettingsProviderApi();

  @override
  Future<ApiResponse> get() async {
    final QueryBuilder<Settings> query = QueryBuilder<Settings>(Settings());
    return getApiResponse<Settings>(await query.query());
  }

  @override
  Future<ApiResponse> update(Settings item) async {
    return getApiResponse<Settings>(await item.save());
  }
}