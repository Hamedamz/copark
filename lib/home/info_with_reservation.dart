import 'package:flutter/material.dart';

class InfoWithReservation extends StatelessWidget {
  const InfoWithReservation({Key? key, required this.parkingNumber})
      : super(key: key);

  final String parkingNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(children: [
              const Text(
                  'شماره پارکینگ شما',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    parkingNumber,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 70,
                    ),
                  ),
                  Icon(
                    Icons.local_parking,
                    color: Colors.green.shade300,
                    size: 60,
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.white),
                ))),
                onPressed: () => {
                  //todo not using my parking today
                },
                child: const Text(
                    'امروز نمیام',
                    style: TextStyle(color: Colors.white),
              ),
              )
            ]
          )
       )
    );
  }
}
