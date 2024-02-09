import 'package:template/network/net_dio.dart' as dio;
import 'net_exception.dart';
import 'net.dart';

class Result<Type> {
  Type? result;
  NetException? exception;
  int? statusCode;
  Net? net;
  dio.Net? dioNet;
  bool isFromCache = false;
  String? token;

  bool isSuccess() {
    if (exception == null) return true;
    return false;
  }
}
