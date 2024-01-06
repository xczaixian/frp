import 'package:chat_room/common/dio_manager.dart';

import 'package:dio/dio.dart';

import 'logger_util.dart';

Future<Map<String, dynamic>> get(String path, Map<String, dynamic> params,
    {bool needToken = true}) async {
  return _http(path, params, true, isNeedToken: needToken);
}

Future<Map<String, dynamic>> post(String path, Map<String, dynamic> params,
    {bool needToken = true, bool isPostJson = false}) async {
  return _http(path, params, false,
      isNeedToken: needToken, isPostJson: isPostJson);
}

Future<Map<String, dynamic>> _http(
    String path, Map<String, dynamic> params, bool isGet,
    {bool isNeedToken = true, bool isPostJson = false}) async {
  Options options = Options();
  options.headers = getHeaders(isNeedToken);
  final String url = getUrl(path);
  logger.d('请求地址：$url，\n请求参数：$params\n');
  try {
    final response;
    if (isGet) {
      response = await DioManager()
          .dio
          .get(url, queryParameters: params, options: options);
    } else {
      if (isPostJson) {
        response =
            await DioManager().dio.post(url, data: params, options: options);
      } else {
        response = await DioManager()
            .dio
            .post(url, queryParameters: params, options: options);
      }
    }
    logger.d('请求正常，返回数据：${response.data.toString()}');
    return response.data;
  } on DioException catch (e) {
    if (e.response != null) {
      logger.d('请求异常，返回数据：${e.response?.data.toString()}');
      return e.response?.data;
    } else {
      logger.d('请求异常，${e.message}');
      return {
        "code": 101009,
        "status": 500,
        "message": e.message,
        "success": false
      };
    }
  }
}
