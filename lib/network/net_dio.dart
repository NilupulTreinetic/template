import 'package:dio/dio.dart';
import '../helpers/local_storage.dart';
import 'net_exception.dart';
import 'net_result.dart';
import 'network_error_handler.dart';

enum NetMethod { GET, POST, DELETE, PUT, MULTIPART }

class Net {
  late String url;
  Map<String, String>? queryParam;
  Map<String, String>? pathParam;
  Map<String, String>? fields;
  Map<String, String>? imagePathList;
  Map<String, String>? headers;
  String test;
  dynamic body;
  NetMethod method;
  bool excludeToken;
  final int _retryMaxCount = 3;
  int _retryCount = 0;
  bool isRetryEnable = false;
  static String? _TOKEN;
  Function(double progress)? onUploadProgress;

  Net({
    required this.url,
    required this.method,
    this.queryParam,
    this.pathParam,
    this.fields,
    this.imagePathList,
    this.headers,
    this.test = "",
    this.excludeToken = false,
    this.onUploadProgress,
  });

  Future<Result> perform() async {
    try {
      late Response response;
      final dio = Dio();

      switch (method) {
        case NetMethod.GET:
          response =
              await dio.get(await processUrl(), queryParameters: queryParam);
          break;
        case NetMethod.POST:
          response = await dio.post(await processUrl(), data: body);
          break;
        case NetMethod.PUT:
          response = await dio.put(await processUrl(), data: body);
          break;
        case NetMethod.DELETE:
          response = await dio.delete(await processUrl(), data: body);
          break;
        case NetMethod.MULTIPART:
          response = await multiPart(dio);
          break;
      }

      return isOk(response);
    } catch (e) {
      throw NetException(message: e.toString());
    }
  }

  Future<Response> multiPart(Dio dio) async {
    final formData = FormData();

    fields?.forEach((key, value) {
      formData.fields.add(MapEntry(key, value));
    });

    imagePathList?.forEach((key, value) async {
      final file = await MultipartFile.fromFile(value);
      formData.files.add(MapEntry(key, file));
    });

    final options = Options(headers: await getHeadersForRequest());

    final response = await dio.post(await processUrl(),
        data: formData, options: options, onSendProgress: (sent, total) {
      if (onUploadProgress != null) {
        onUploadProgress!(sent / total * 100);
      }
    });

    return response;
  }

  Future<String> processUrl() async {
    return "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";
  }

  Future<Map<String, String>> getHeadersForRequest() async {
    headers ??= {};
    if (_TOKEN == null || _TOKEN == "") {
      _TOKEN = await LocalStorage().getUserToken();
    }
    if (_TOKEN != null &&
        !headers!.containsKey("Authorization") &&
        !excludeToken) {
      headers!["Authorization"] = _TOKEN!;
    }
    headers!.putIfAbsent("Content-Type", () => "application/json");
    headers!.putIfAbsent("Accept", () => "application/json");
    return headers!;
  }

  String getPathParameters(String netUrl) {
    String url = netUrl;
    pathParam ??= {};
    if (pathParam!.isNotEmpty) {
      pathParam!.forEach((key, value) {
        url = url.replaceFirst(key, value);
      });
    }
    return url;
  }

  Future<Result> isOk(Response response) {
    final result = Result();
    result.statusCode = response.statusCode!;
    result.dioNet = this;
    result.token = response.headers.map["authorization"]?.first;

    final netException = DioNetworkErrorHandler.handleError(response);
    if (netException != null) {
      if (!isRetryEnable) {
        result.exception = netException;
        return Future.value(result);
      }
      if (_retryCount >= _retryMaxCount) {
        result.exception = netException;
        return Future.value(result);
      }

      _retryCount++;
      return perform();
    }

    result.result = response.data;
    return Future.value(result);
  }
}
