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
                  const SizedBox(height: 20),
                  const Text('قیمت پیشنهادی شما'),
                  const SizedBox(height: 20),
                  Text(
                      bid.toString(),
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
  }
}
