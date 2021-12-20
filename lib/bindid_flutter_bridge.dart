
import 'dart:async';

import 'package:flutter/services.dart';

class BindidFlutterBridge {

  static const String bindid_init_done = "bindid_init_done";


  static const MethodChannel _channel =
      const MethodChannel('bindid_flutter_bridge');

  static Future<String> initBindID(bindIDHost, bindIDClientId) async {
    Map<String, dynamic> data = <String, dynamic>{
      "bindid_host": bindIDHost,
      "bindid_client_id": bindIDClientId
    };
    final String status = await _channel.invokeMethod('initBindId', data);
    return status;
  }

  static Future<Map<dynamic, dynamic>> authenticate(bindIDRedirectUri) async {
    Map<String, dynamic> data = <String, dynamic>{
      "bindid_redirect_uri": bindIDRedirectUri
    };
    final Map<dynamic, dynamic> token = await _channel.invokeMethod('authenticate', data);
    return token;
  }

}
