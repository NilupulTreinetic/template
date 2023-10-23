// ignore_for_file: non_constant_identifier_names
// ignore: constant_identifier_names
import 'dart:convert';
import 'dart:io';
import '../helpers/app_logger.dart';
import '../helpers/local_storage.dart';
import 'cache_network_service.dart';
import 'net_exception.dart';
import 'net_result.dart';
import 'package:http/http.dart' as http;
import 'network_error_handler.dart';

// ignore: constant_identifier_names
enum NetMethod { GET, POST, DELETE, PUT, MULTIPART }

class Net {
  String url;
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
  });

  Future<Result> perform() async {
    http.Response response;
    switch (method) {
      case NetMethod.GET:
        response = await get();
        break;
      case NetMethod.POST:
        response = await post();
        break;
      case NetMethod.PUT:
        response = await put();
        break;
      case NetMethod.DELETE:
        response = await delete();
        break;
      case NetMethod.MULTIPART:
        response = await multiPart();
        break;
    }

    return await isOk(response);
  }

  Future<http.Response> get() async {
    Log.debug("request - GET | url - $url | ");
    String url_ =
        "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";

    Uri uri = Uri.parse(url_);
    var headers = await getHeadersForRequest();
    Log.debug('------headers-----${headers.toString()}');

    Log.debug("request - GET | url - $uri | headers - ${headers.toString()}");
    final response = await http.get(uri, headers: headers);

    Log.debug(
        "response - GET | url - $uri | body - ${response.body}| headers - ${response.headers.toString()}");
    return response;
  }

  Future<http.Response> post() async {
    String url_ =
        "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";

    Uri uri = Uri.parse(url_);

    var headers = await getHeadersForRequest();
    Log.debug("request - POST | url - $url_ | headers - ${headers.toString()}");

    final response = await http.post(
      uri,
      headers: headers,
      body: body == null ? "" : jsonEncode(body),
    );

    Log.debug(
        "response - POST | url - $url_ | body - ${response.body}| headers - ${response.headers.toString()}");

    return response;
  }

  Future<http.Response> put() async {
    Log.debug("request - PUT | url - $url | ");
    String url_ =
        "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";
    Uri uri = Uri.parse(url_);
    var headers = await getHeadersForRequest();

    Log.debug("request - PUT | url - $url_ | headers - ${headers.toString()}");
    final response = await http.put(
      uri,
      headers: headers,
      body: body == null ? "" : jsonEncode(body),
    );
    Log.debug(
        "response - PUT | url - $url_ | body - ${response.body}| headers - ${response.headers.toString()}");
    return response;
  }

  Future<http.Response> delete() async {
    String url_ =
        "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";
    Uri uri = Uri.parse(url_);

    var headers = await getHeadersForRequest();

    Log.debug(
        "request - DELETE | url - $url_ | headers - ${headers.toString()}");

    final response = await http.delete(
      uri,
      headers: headers,
      body: body == null ? "" : jsonEncode(body),
    );

    Log.debug(
        "response - DELETE | url - $url_ | body - ${response.body}| headers - ${response.headers.toString()}");
    return response;
  }

  Future<http.Response> multiPart() async {
    List<http.MultipartFile> multipartFiles = [];

    String url_ =
        "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";
    Uri uri = Uri.parse(url_);

    var headers = await getHeadersForRequest();

    Log.debug(
        "request - MULTIPART | url - $url_ | headers - ${headers.toString()}");

    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(headers);
    fields ??= {};
    fields!.forEach((key, value) {
      request.fields['$key'] = value;
    });
    imagePathList ??= {};
    List<dynamic> data = imagePathList!.entries.cast().toList();

    for (var i = 0; i < data.length; i++) {
      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('${data[i].key}', data[i].value);

      multipartFiles.add(multipartFile);
    }

    request.files.addAll(multipartFiles);

    var response = await request.send();

    var body = await response.stream.bytesToString();
    Log.debug("http api multipart- ${response.statusCode}$body");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      Log.debug(
          '------ server error: statusCode - ${response.statusCode} -----');
    }

    http.Response res = http.Response(body, response.statusCode);
    return res;
  }

  printMap(Map map) {
    for (final e in map.entries) {
      Log.debug('${e.key} = ${e.value}');
    }
  }

  Future<Map<String, String>> getHeadersForRequest() async {
    headers ??= {};
    if (_TOKEN != null || _TOKEN != "") {
      Log.debug("token get from local");
      _TOKEN = await LocalStorage().getUserToken();
    }
    if (_TOKEN != null &&
        !headers!.containsKey(HttpHeaders.authorizationHeader) &&
        !excludeToken) {
      Log.debug("token set to headers");
      headers!.putIfAbsent(HttpHeaders.authorizationHeader, () => _TOKEN ?? '');
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
        Log.debug("$key path param replaced");
      });
    }
    return url;
  }

  Future<Result> isOk(http.Response response) async {
    Result result = Result();
    result.statusCode = response.statusCode;
    result.net = this;
    result.token = response.headers['authorization'];

    NetException? netException = NetworkErrorHandler.handleError(response);
    if (netException != null) {
      Log.err("error found");
      if (!isRetryEnable) {
        try {
          Log.err("network error ${response.statusCode} recorded in firebase!");
        } catch (err) {}
        Log.debug("retry disabled!");
        result.exception = netException;
        return result;
      }
      if (_retryCount >= _retryMaxCount) {
        try {
          Log.err("network error ${netException.code} recorded in firebase!");
        } catch (err) {}
        Log.err("retry failed!");
        result.exception = netException;
        return result;
      }

      _retryCount++;
      Log.debug("retry again.. $_retryCount time");
      return await result.net!.perform();
    }

    result.result = response.body;
    return result;
  }

  Future<String> processUrl() async {
    return "${getPathParameters(url)}?${Uri(queryParameters: queryParam).query}";
  }

  // recordError(http.Response response, Result result) async {
  //   if (result.net != null) {
  //     await FirebaseCrashlytics.instance
  //         .setCustomKey(result.net!.url, response.body);

  //     await FirebaseCrashlytics.instance
  //         .log("${result.net!.url} --- ${response.body}");

  //     await FirebaseCrashlytics.instance.recordError(
  //         "SERVER ERROR ${response.statusCode}",
  //         StackTrace.fromString(response.body));
  //   }
  // }
}
