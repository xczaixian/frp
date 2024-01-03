import 'dart:io';

import 'package:chat_room/common/dio_manager.dart';

import 'package:dio/dio.dart';

import 'logger_util.dart';

Future<Map<String, dynamic>> get(String path, Map<String, dynamic> params,
    {bool needToken = true}) async {
  Options options = Options();
  options.headers = getHeaders(needToken);
  final String url = getUrl(path);
  final response = await DioManager()
      .dio
      .get(url, queryParameters: params, options: options);
  logger.d('请求地址：$url，\n请求参数：$params，\n返回数据：${response.data.toString()}');
  return response.data;
}

Future<Map<String, dynamic>> post(String path, Map<String, dynamic> params,
    {bool needToken = true}) async {
  Options options = Options();
  options.headers = getHeaders(needToken);
  final String url = getUrl(path);
  logger.d('请求地址：$url，\n请求参数：$params，');
  final response = await DioManager()
      .dio
      .post(url, queryParameters: params, options: options);
  logger.d('请求地址：$url，\n请求参数：$params，\n返回数据：${response.data.toString()}');
  return response.data;
}
