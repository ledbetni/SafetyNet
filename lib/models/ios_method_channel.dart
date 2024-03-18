import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NativeBridge {
  static const _platform = MethodChannel('com.safetynet/mapsApiKey');

  static Future<void> setApiKey() async {
    try {
      final String apiKey = dotenv.env['IOS_GOOGLE_MAP_API_KEY']!;
      await _platform.invokeMethod('setApiKey', {'apiKey': apiKey});
    } on PlatformException catch (e) {
      print("Failed to set API key: '${e.message}'.");
    }
  }
}
