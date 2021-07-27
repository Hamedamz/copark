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
  Settings? _settings;
  final TextEditingController _minimumPriceController =
      TextEditingController(text: '0');
  final TextEditingController _parkCountController =
      TextEditingController(text: '0');
  final TextEditingController _auctionInprogressDaysController =
      TextEditingController(text: '0');
  final TextEditingController _auctionNewDaysController =
      TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    prepareSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (_settings == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scrollbar(
      child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            ...[
              TextFormField(
                restorationId: 'min_price',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _minimumPriceController,
                onChanged: (value) {
                  final num? number = num.tryParse(value);
                  if (number != null) {
                    _settings?.minimumPrice = number;
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'حداقل قیمت',
                    suffixText: 'تومان'),
              ),
              TextFormField(
                restorationId: 'parking_count',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _parkCountController,
                onChanged: (value) {
                  final num? number = num.tryParse(value);
                  if (number != null) {
                    _settings?.parkCount = number;
                  }
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'تعداد پارکینگ',
                ),
              ),
              TextFormField(
                restorationId: 'progress_days',
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _auctionInprogressDaysController,
                onChanged: (value) {
                  final num? number = num.tryParse(value);
                  if (number != null) {
                    _settings?.auctionInprogressDays = number;
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'طول مزایده',
                    suffixText: 'روز'),
              ),
              TextFormField(
                restorationId: 'new_days',
                textInputAction: TextInputAction.go,
                keyboardType: TextInputType.number,
                controller: _auctionNewDaysController,
                onChanged: (value) {
                  final num? number = num.tryParse(value);
                  if (number != null) {
                    _settings?.auctionNewDays = number;
                  }
                },
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'فاصله‌ی بین دو مزایده',
                    suffixText: 'روز'),
              ),
              MaterialButton(
                color: Colors.blue.shade600,
                onPressed: () => {saveSetting()},
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
    );
  }

  void prepareSettings() async {
    ApiResponse response = await StaticModels.settingsRepo!.get();
    setState(() {
      _settings = response.result;
      _auctionInprogressDaysController.text =
          '${_settings!.auctionInprogressDays}';
      _auctionNewDaysController.text = '${_settings!.auctionNewDays}';
      _minimumPriceController.text = '${_settings!.minimumPrice}';
      _parkCountController.text = '${_settings!.parkCount}';
    });
  }

  saveSetting() async {
    final response = await _settings!.save();
    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تغییرات ذخیره شد'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تغییرات ذخیره نشد'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }
}
