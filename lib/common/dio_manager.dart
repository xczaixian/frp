import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '../common/login_manager.dart';

import '../api/config.dart';

class DioManager {
  static final DioManager _shared = DioManager._internal();

  late Dio dio;

  factory DioManager() {
    return _shared;
  }

  DioManager._internal() {
    dio = Dio();
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) {
          return true; // 不验证证书
        };
        return client;
      },
    );
  }
}

String getUrl(String path) {
  if (!path.startsWith('/')) {
    path = '/$path';
  }
  return '${ApiConfig.host}$path';
}

Map<String, dynamic> getHeaders(bool needToken) {
  return {
    'Accept-Language': 'en_US',
    'Authorization': 'Bearer${needToken ? getToken : ''}',
    'gatev': '1.0.0',
    'deviceId': getDeviceId,
    'OsType': getOsType,
    'deviceBrand': getDeviceBrand,
  };
}

String _deviceId = '123456';
String _osType = 'android';
String _deviceBrand = 'xiaomi';

String get getDeviceId => _deviceId;

String get getOsType => _osType;

String get getDeviceBrand => _deviceBrand;
