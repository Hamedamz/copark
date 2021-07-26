import 'dart:convert' as json;

import 'package:copark/data/api/api_error.dart';
import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/settings.dart';
import 'package:copark/data/repositories/settings/contract_settings.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sembast/sembast.dart';

class SettingsProviderDB implements SettingsContract {
  SettingsProviderDB(this._db, this._store);

  final StoreRef<String, Map<String, dynamic>> _store;
  final Database _db;

  @override
  Future<ApiResponse> get() async {
    final List<Settings> items = <Settings>[];

    final Finder finder = Finder();

    final List<RecordSnapshot<String, Map<String, dynamic>>>? records =
        await _store.find(_db, finder: finder);

    if (records == null || records.isEmpty) {
      return errorResponse;
    }

    for (final RecordSnapshot<String, Map<String, dynamic>> record
        in records) {
      final Settings? convertedSettings = convertRecordToItem(record: record);
      items.add(convertedSettings!);
    }

    return ApiResponse(true, 200, items, null);
  }

  Future<ApiResponse> add(Settings item) async {
    final Map<String, dynamic> values = convertItemToStorageMap(item);
    await _store.record(item.objectId!).put(_db, values);
    final Map<String, dynamic>? recordFromDB =
    await _store.record(item.objectId!).get(_db);

    return ApiResponse(
        true, 200, <dynamic>[convertRecordToItem(values: recordFromDB)], null);
  }

  @override
  Future<ApiResponse> update(Settings item) async {
    final Map<String, dynamic> values = convertItemToStorageMap(item);
    final Finder finder =
    Finder(filter: Filter.equals('objectId', item.objectId));
    final int returnedCount = await _store.update(_db, values, finder: finder);

    if (returnedCount == 0) {
      return add(item);
    }

    return ApiResponse(true, 200, <dynamic>[item], null);
  }

  Map<String, dynamic> convertItemToStorageMap(Settings item) {
    final Map<String, dynamic> values = <String, dynamic>{};
    values['value'] = json.jsonEncode(item.toJson(full: true));
    values[keyVarObjectId] = item.objectId;
    if (item.updatedAt != null) {
      values[keyVarUpdatedAt] = item.updatedAt!.millisecondsSinceEpoch;
    }
    return values;
  }

  Settings? convertRecordToItem(
      {RecordSnapshot<String, Map<String, dynamic>>? record,
      Map<String, dynamic>? values}) {
    try {
      values ??= record!.value;
      final Settings item =
          Settings.clone().fromJson(json.jsonDecode(values['value']));
      return item;
    } catch (e) {
      return null;
    }
  }

  static ApiError error = ApiError(1, 'No records found', null, '');
  ApiResponse errorResponse = ApiResponse(false, 1, null, error);
}
