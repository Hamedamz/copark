import 'package:copark/data/model/auction.dart';
import 'package:copark/data/model/offer.dart';
import 'package:copark/static_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserOffers extends StatefulWidget {
  const UserOffers({Key? key}) : super(key: key);

  @override
  _UserOffersState createState() => _UserOffersState();
}

class _UserOffersState extends State<UserOffers> {
  bool _initialized = false;
  Auction? _newAuction;
  final pageSize = 10;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    final response = await StaticModels.auctionRepo?.getNew();
    if(response?.success == true) {
      _newAuction = response?.result;
    }
    setState(() {
      _initialized = true;
      _isLoading = true;
    });
    _loadData();

  }

  Future<void> _loadData() async {
    if(_newAuction == null) {
      return;
    }
    final response = await StaticModels.offerRepo?.all(_newAuction!, _offers.length, pageSize);
    if (response != null && response.success && response.count > 0) {
      for (var offer in response.results!) {
        _offers.add(offer);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  final List<Offer> _offers = [];

  final textStyle = const TextStyle(color: Colors.white);

  Widget _buildOffersList() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _offers.length,
      itemBuilder: (context, i) {
        return _buildUser(i);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider();
      },
    );
  }

  Widget _buildUser(int index) {
    return ListTile(
        title: Text(_offers[index].user.username ?? ''),
        trailing: Text(
          '${_offers[index].price} تومان ',
          style: const TextStyle(color: Colors.green),
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if(_newAuction == null) {
      return const Center(
        child: Text('در حال حاضر مزائده‌ای در حال برگزاری نیست.'),
      );
    }
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isLoading &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadData();
          // start loading data
          setState(() {
            _isLoading = true;
          });
          return true;
        }
        return true;
      },
      child: _buildOffersList(),
    );
  }
}
