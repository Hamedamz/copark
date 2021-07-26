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
    return Center(
          child: Column(children: [
            Text(
                'حداقل قیمت: ${settings == null ? 0 : settings!.minimumPrice}   ریال'),
            Text('تعداد پارکینگ‌ها: ${settings == null ? 0 : settings!.parkCount}')
          ]),
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