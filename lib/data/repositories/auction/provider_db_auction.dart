import 'dart:convert' as json;

import 'package:copark/data/api/api_error.dart';
import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/auction.dart';
import 'package:copark/data/repositories/auction/contract_auction.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sembast/sembast.dart';

class AuctionProviderDB implements AuctionContract {
  AuctionProviderDB(this._db, this._store);

  final StoreRef<String, Map<String, dynamic>> _store;
  final Database _db;

  @override
  Future<ApiResponse> getNew() async {
    final List<Auction> items = <Auction>[];

    final Finder finder =
        Finder(filter: Filter.equals(keyAuctionStatus, 'new'));

    final List<RecordSnapshot<String, Map<String, dynamic>>>? records =
        await _store.find(_db, finder: finder);

    if (records == null) {
      return errorResponse;
    }

    for (final RecordSnapshot<String, Map<String, dynamic>> record
        in records) {
      final Auction? convertedDietPlan = convertRecordToItem(record: record);
      items.add(convertedDietPlan!);
    }

    return ApiResponse(true, 200, items, null);
  }

  @override
  Future<ApiResponse> updateAll(List<dynamic> items) async {
    final List<Auction> updatedItems = <Auction>[];

    for (final Auction item in items) {
      final ApiResponse response = await update(item);
      if (response.success) {
        final Auction responseItem = response.result;
        updatedItems.add(responseItem);
      }
    }

    return ApiResponse(true, 200, updatedItems, null);
  }

  Future<ApiResponse> update(Auction item) async {
    final Map<String, dynamic> values = convertItemToStorageMap(item);
    final Finder finder =
    Finder(filter: Filter.equals('objectId', item.objectId));
    final int returnedCount = await _store.update(_db, values, finder: finder);

    if (returnedCount == 0) {
      return add(item);
    }

    return ApiResponse(true, 200, <dynamic>[item], null);
  }

  Future<ApiResponse> add(Auction item) async {
    final Map<String, dynamic> values = convertItemToStorageMap(item);
    await _store.record(item.objectId!).put(_db, values);
    final Map<String, dynamic>? recordFromDB =
    await _store.record(item.objectId!).get(_db);

    return ApiResponse(
        true, 200, <dynamic>[convertRecordToItem(values: recordFromDB)], null);
  }

  Map<String, dynamic> convertItemToStorageMap(Auction item) {
    final Map<String, dynamic> values = <String, dynamic>{};
    values['value'] = json.jsonEncode(item.toJson(full: true));
    values[keyVarObjectId] = item.objectId;
    if (item.updatedAt != null) {
      values[keyVarUpdatedAt] = item.updatedAt!.millisecondsSinceEpoch;
    }
    return values;
  }

  Auction? convertRecordToItem(
      {RecordSnapshot<String, Map<String, dynamic>>? record,
      Map<String, dynamic>? values}) {
    try {
      values ??= record!.value;
      final Auction item =
          Auction.clone().fromJson(json.jsonDecode(values['value']));
      return item;
    } catch (e) {
      return null;
    }
  }

  static ApiError error = ApiError(1, 'No records found', null, '');
  ApiResponse errorResponse = ApiResponse(false, 1, null, error);
}
