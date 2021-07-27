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
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Text(
                          daysToStart.toString(),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 36,
                          ),
                      ),
                      const Text('روز'),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  const Text('مانده تا مزایده‌ی بعدی'),
                ]
            )
        )
    );
  }
}
