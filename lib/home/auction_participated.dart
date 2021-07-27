import 'package:copark/data/state/auction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuctionParticipated extends StatelessWidget {
  const AuctionParticipated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuctionModel>(
        builder: (context, auction, child) {
          return Container(
              child: Center(
                  child: Column(
                      children: [
                        const Text('شما در مزایده شرکت کرده‌اید'),
                        const SizedBox(height: 20),
                        const Text('قیمت پیشنهادی شما'),
                        const SizedBox(height: 20),
                        Text(
                          auction.bid.toString(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 36,
                          ),
                        ),
                        const Text(
                          'تومان',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ]
                  )
              )
          );
        });
  }
}
