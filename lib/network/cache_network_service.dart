import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:template/network/cache_service.dart';
import 'package:template/network/net.dart';
import '../helpers/app_logger.dart';
import '../helpers/connectivity_manager.dart';
import 'hive_cache_manager.dart';
import 'net_exception.dart';
import 'net_result.dart';

class CacheNetworkService extends Net {
  CacheService? cacheService;
  bool isCacheEnable;
  Duration cacheDuration;
  bool isBodyAddToKey;

  CacheNetworkService({
    required String url,
    required NetMethod method,
    Map<String, String> queryParam = const {},
    Map<String, String> pathParam = const {},
    Map<String, String> headers = const {},
    this.isCacheEnable = false,
    this.cacheDuration = const Duration(minutes: 30),
    this.isBodyAddToKey = false,
  }) : super(
          url: url,
          method: method,
          queryParam: queryParam,
          pathParam: pathParam,
          headers: headers,
        );

  initCacheService({required String hiveBox}) async {
    cacheService = HiveCacheManager();
    await cacheService!.init(hiveBox);
  }

  Future<Result> perform() async {
    Result result = Result();
    var key = await processUrl();

    if (isBodyAddToKey && isCacheEnable) {
      key += "?body=${jsonEncode(body)}";
    }

    if (isCacheEnable) {
      var localDataMap = await cacheService!.getLocalData(key);
      if (localDataMap != null &&
          localDataMap is Map &&
          localDataMap.isNotEmpty) {
        if (localDataMap['timeStamp'] != null) {
          int lastTimeStamp = localDataMap['timeStamp'];
          int currentTimeStamp = DateTime.now().microsecondsSinceEpoch;
          int timeDiff = currentTimeStamp - lastTimeStamp;

          var formatter = DateFormat('MM/dd/yyyy, hh:mm a');

          var lastTimeDate = formatter
              .format(DateTime.fromMicrosecondsSinceEpoch(lastTimeStamp));

          Log.debug(
              "timeDiff ${timeDiff / Duration.microsecondsPerMinute}m - lastTimeStamp ${lastTimeDate.toString()} - duration ${cacheDuration.inMicroseconds / Duration.microsecondsPerMinute}m");

          if (timeDiff < cacheDuration.inMicroseconds) {
            Log.debug("cache not expired");
            if (localDataMap['data'] != null) {
              var localData = localDataMap['data'];
              result.result = localData;
              result.isFromCache = true;
              return result;
            }
          }
          Log.debug("cache expired sending new req");
        }
      }
    }

    if (await ConnectivityManager.connected()) {
      Log.debug("internet available. sending request!");
      result = await super.perform();
      if (result.exception == null) {
        await cacheService!.saveToLocal(key, result.result);
      }
    }
    var localDataMap = await cacheService!.getLocalData(key);

    var localData = localDataMap;
    if (localDataMap is Map && localDataMap['data'] != null) {
      localData = localDataMap['data'];
    }

    if (localData == null && result.exception == null) {
      result.exception = NetException(
          message: "No data found from local database!",
          messageId: "EMPTY_DATA",
          code: 000);
    }

    result.result = localData;
    return result;
  }
}
