import 'package:flutter/material.dart';

class InfoWithReservation extends StatelessWidget {
  const InfoWithReservation({Key? key, required this.parkingNumber}) : super(key: key);

  final String parkingNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
                children: [
                  const Text('شماره پارکینگ شما'),
                  Text(parkingNumber),
                  MaterialButton(
                      onPressed: () => {
                        //todo not using my parking today
                      },
                      child: const Text('امروز نمیام'),
                  )
                ]
            )
        )
    );
  }
}
