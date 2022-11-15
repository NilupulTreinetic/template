import 'dart:convert';
import 'package:hive/hive.dart';
import '../helpers/app_logger.dart';
import 'cache_service.dart';

class HiveCacheManager implements CacheService {
  Box? box;
  static const int version = 1;
  static const String versionBox = "version_box";
  final String _versionKey = "hive_version";

  @override
  init(name) async {
    if (box == null) {
      box = await Hive.openBox(name);
      Log.debug("$name init CacheService success!");
    }
  }

  @override
  delete() {
    Hive.deleteFromDisk();
    Log.debug("All boxes deleted");
  }

  @override
  getLocalData(key) async {
    if (box == null) return null;

    if (box!.toMap().isNotEmpty && box!.containsKey(key)) {
      return json.decode(box!.get(key));
    }
    return null;
  }

  @override
  saveToLocal(key, value) async {
    Map<String, dynamic> data = {
      "timeStamp": DateTime.now().microsecondsSinceEpoch,
      "data": value,
    };
    box!.put(key, json.encode(data));
    Log.debug("saved $key - $value");
  }

  @override
  setVersion() async {
    await box!.put(_versionKey, version);
    Log.debug("$_versionKey-$version saved");
  }

  @override
  getVersion() async {
    if (box == null) return null;
    return box!.get(_versionKey);
  }
}
