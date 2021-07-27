import 'package:copark/data/api/api_response.dart';
import 'package:copark/data/model/settings.dart';
import 'package:copark/static_models.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class AuctionSettings extends StatefulWidget {
  const AuctionSettings({Key? key}) : super(key: key);

  @override
  _AuctionSettingsState createState() => _AuctionSettingsState();
}

class _AuctionSettingsState extends State<AuctionSettings> {
  Settings? settings;

  @override
  Widget build(BuildContext context) {
    prepareSettings();

    var _minimumPrice = settings == null ? 0 : settings?.minimumPrice;
    var _parkCount = settings == null ? 0 : settings?.parkCount;
    var _auctionInprogressDays =
        settings == null ? 0 : settings?.auctionInprogressDays;
    var _auctionNewDays = settings == null ? 0 : settings?.auctionNewDays;
    // return Center(
    //       child: Column(children: [
    //         Text(
    //             'حداقل قیمت: ${settings == null ? 0 : settings!.minimumPrice}   ریال'),
    //         Text('تعداد پارکینگ‌ها: ${settings == null ? 0 : settings!.parkCount}')
    //       ]),
    //     );
    return Container(
      child: Scrollbar(
        child: SingleChildScrollView(
            padding: new EdgeInsets.all(20.0),
            child: Column(children: [
              ...[
                TextFormField(
                  restorationId: 'min_price',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  initialValue: _minimumPrice.toString(),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'حداقل قیمت',
                      suffixText: 'تومان'),
                ),
                TextFormField(
                  restorationId: 'parking_count',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  initialValue: _parkCount.toString(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'تعداد پارکینگ',
                  ),
                ),
                TextFormField(
                  restorationId: 'progress_days',
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  initialValue: _auctionInprogressDays.toString(),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'طول مزایده',
                      suffixText: 'روز'),
                ),
                TextFormField(
                  restorationId: 'new_days',
                  textInputAction: TextInputAction.go,
                  keyboardType: TextInputType.number,
                  initialValue: _auctionNewDays.toString(),
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'فاصله‌ی بین دو مزایده',
                      suffixText: 'روز'),
                ),
                MaterialButton(
                  color: Colors.blue.shade600,
                  onPressed: () => {
                    //todo save changes
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('تغییرات ذخیره شد'),
                        backgroundColor: Colors.green,
                      ),
                    )
                  },
                  textColor: Colors.white,
                  height: 50,
                  elevation: 0,
                  minWidth: 400,
                  child: const Text('ذخیره تغییرات'),
                )
              ].expand(
                (widget) => [
                  widget,
                  const SizedBox(
                    height: 24,
                  )
                ],
              )
            ])),
      ),
    );
  }

  void showSettings(Settings settings) {
    settings.pin();
    setState(() {
      this.settings = settings;
    });
  }

  void prepareSettings() {
    Future<ApiResponse> response = StaticModels.settingsRepo!.get();
    response.then((value) => {showSettings(value.result)});
  }
}
