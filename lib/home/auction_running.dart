import 'package:flutter/material.dart';

class AuctionRunning extends StatelessWidget {
  const AuctionRunning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => {
              //todo participate in auction
            },
            minWidth: 400,
            elevation: 0,
            height: 50,
            textColor: Colors.white,
            child: const Text('شرکت در مزایده'),
          )
        ]));
  }
}
