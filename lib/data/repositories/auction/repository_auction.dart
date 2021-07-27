import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/auction.dart';
import 'package:copark/data/repositories/auction/contract_auction.dart';
import 'package:copark/data/repositories/auction/provider_api_auction.dart';
import 'package:copark/data/repositories/auction/provider_db_auction.dart';
import 'package:sembast/sembast.dart';

class AuctionRepository implements AuctionContract {
  static AuctionRepository init(Database dbConnection) {
    final AuctionRepository repository = AuctionRepository();

    final StoreRef<String, Map<String, dynamic>> store =
        stringMapStoreFactory.store('repository_auction');
    repository.db = AuctionProviderDB(dbConnection, store);

    repository.api = AuctionProviderApi();

    return repository;
  }

  late AuctionContract api;
  late AuctionContract db;

  @override
  Future<ApiResponse> getNew(
      {bool fromApi = false, bool fromDb = false}) async {
    if (fromApi) {
      return await api.getNew();
    }
    if (fromDb) {
      return await db.getNew();
    }
    final ApiResponse response = await api.getNew();

    if (response.success && response.results != null) {
      await db.updateAll(response.results!);
    }
    return response;
  }

  @override
  Future<ApiResponse> add(Auction item,
      {bool apiOnly = false, bool dbOnly = false}) async {
    if (apiOnly) {
      return await api.add(item);
    }
    if (dbOnly) {
      return await db.add(item);
    }

    final ApiResponse response = await api.add(item);
    if (response.success) {
      await db.add(item);
    }

    return response;
  }

  @override
  Future<ApiResponse> update(Auction item,
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

  @override
  Future<ApiResponse> updateAll(List<dynamic> items,
      {bool apiOnly = false, bool dbOnly = false}) async {
    if (apiOnly) {
      await api.updateAll(items);
    }
    if (dbOnly) {
      await db.updateAll(items);
    }

    ApiResponse response = await api.updateAll(items);
    if (response.success && response.results != null) {
      response = await db.updateAll(response.results!);
    }

    return response;
  }
}
