import 'package:flutter/material.dart';

class AuctionNotStarted extends StatelessWidget {
  const AuctionNotStarted({Key? key, required this.daysToStart}) : super(key: key);

  final int daysToStart;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
                children: [
                  const Text('مزایده هنوز شروع نشده است'),
                  Row(
                    children: [
                      Text(daysToStart.toString()),
                      const Text('روز'),
                    ],
                  ),
                  const Text('مانده تا مزایده‌ی بعدی'),
                ]
            )
        )
    );
  }
}
