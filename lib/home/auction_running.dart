import 'package:flutter/material.dart';

class AuctionRunning extends StatelessWidget {
  const AuctionRunning({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
                children: [
                  const Text('مزایده در حال برگزاری است'),
                  const Text('مبلغ پیشنهادی خود را وارد کنید'),
                  TextFormField(
                    restorationId: 'bid',
                    textInputAction: TextInputAction.go,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'قیمت پیشنهادی',
                      suffixText: 'تومان'
                    ),
                  ),
                  MaterialButton(
                    color: Colors.blue,
                    onPressed: () => {
                      //todo participate in auction
                    },
                    minWidth: 400,
                    child: const Text('شرکت در مزایده'),
                  )
                ]
            )
        )
    );
  }
}
