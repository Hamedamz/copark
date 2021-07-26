import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/settings.dart';
import 'package:copark/data/repositories/settings/provider_api_settings.dart';
import 'package:copark/data/repositories/settings/provider_db_settings.dart';
import 'package:sembast/sembast.dart';

import 'contract_settings.dart';

class SettingsRepository implements SettingsContract {
  static SettingsRepository init(Database dbConnection) {
    final SettingsRepository repository = SettingsRepository();

    final StoreRef<String, Map<String, dynamic>> store =
        stringMapStoreFactory.store('repository_settings');
    repository.db = SettingsProviderDB(dbConnection, store);

    repository.api = SettingsProviderApi();

    return repository;
  }

  late SettingsContract api;
  late SettingsContract db;

  @override
  Future<ApiResponse> get(
      {bool fromApi = false, bool fromDb = false}) async {
    if (fromApi) {
      return await api.get();
    }
    if (fromDb) {
      return await db.get();
    }
    ApiResponse response = await db.get();

    if (response.success) {
      return response;
    }

    response = await api.get();

    if (response.success) {
      await db.update(response.result);
    }
    return response;
  }

  @override
  Future<ApiResponse> update(Settings item,
      {bool apiOnly = false, bool dbOnly = false}) async {
    if (apiOnly) {
      return await api.update(item);
    }
    if (dbOnly) {
      return await db.update(item);
    }

    ApiResponse response = await api.update(item);
    response = await db.update(item);
    return response;
  }
}
