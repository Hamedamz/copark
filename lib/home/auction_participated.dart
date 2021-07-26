import 'package:flutter/material.dart';

class AuctionParticipated extends StatelessWidget {
  const AuctionParticipated({Key? key, required this.bid}) : super(key: key);

  final int bid;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
                children: [
                  const Text('شما در مزایده شرکت کرده‌اید'),
                  const Text('قیمت پیشنهادی شما'),
                  Text(bid.toString()),
                ]
            )
        )
    );
  }
}
