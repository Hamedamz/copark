import 'package:copark/data/model/offer.dart';
import 'package:copark/data/state/auction.dart';
import 'package:copark/static_models.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:provider/provider.dart';

import 'auction.dart';

typedef OfferAdded = void Function();

class AuctionRunning extends StatelessWidget {
  AuctionRunning({Key? key}) : super(key: key);

  final myController = TextEditingController();
  late BuildContext context;

  @override
  Widget build(BuildContext context1) {
    return Consumer<AuctionModel>(
      builder: (context, auction, child)
    {
      this.context = context;
      return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('مزایده در حال برگزاری است'),
                const SizedBox(height: 10),
                const Text('مبلغ پیشنهادی خود را وارد کنید'),
                const SizedBox(height: 20),
                TextFormField(
                  controller: myController,
                  restorationId: 'bid',
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'قیمت پیشنهادی',
                      suffixText: 'تومان'),
                ),
                const SizedBox(height: 20),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () =>
                  {
                    offerBid(auction, myController.text)
                  },
                  minWidth: 400,
                  elevation: 0,
                  height: 50,
                  textColor: Colors.white,
                  child: const Text('شرکت در مزایده'),
                )
              ]));
    });
  }

  Future<void> offerBid(AuctionModel auctionModel, String text) async {
    Offer offer = Offer();
    offer.price = int.parse(text);
    offer.user = StaticModels.user!;
    offer.auction = StaticModels.newAuction!;

    ParseResponse response = await offer.save();
    if (response.success) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(
          content: Text('پیشنهاد شما با موفقیت ثبت شد.'),
          backgroundColor: Colors.green,
        ),
      );
      auctionModel.isUserParticipated = true;
      auctionModel.isStarted = false;
      auctionModel.bid = offer.price;
    } else {
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(
          content: Text('متاسفانه مشکلی در ثبت پیشنهاد شما وجود دارد.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
