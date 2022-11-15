import 'dart:convert';
import '../helpers/app_logger.dart';
import '../network/net_exception.dart';
import '../network/cache_network_service.dart';
import '../network/net.dart';
import '../network/net_result.dart';
import '../network/net_url.dart';

class UserService {
  static const BOX_NAME = "userService";
  static final UserService _singleton = UserService._internal();
  static const String MAX_RESULTS_PER_PAGE = "20";

  factory UserService() {
    return _singleton;
  }

  UserService._internal();

  Future<Result> fetchUserProfile({bool isCacheEnable = false}) async {
    Result result = Result();
    try {
      var net = CacheNetworkService(
        url: URL.SIGN_UP,
        method: NetMethod.GET,
        isCacheEnable: isCacheEnable,
        // cacheDuration: CacheDuration.INIT_USER,
      );

      await net.initCacheService(hiveBox: BOX_NAME);

      result = await net.perform();
      Log.debug("result is **** ${result.result}");

      if (result.exception == null && result.result != "") {
        var user = json.decode(result.result);
        // result.result = User.fromJson(user);
      }
      return result;
    } catch (err) {
      Log.err("$err");
      result.exception = NetException(
          message: CommonMessages.LOGIN_ERROR,
          messageId: CommonMessageId.LOGIN_ERROR,
          code: ExceptionCode.CODE_000);
      return result;
    }
  }
}
