import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Utils {
  
  Future<String> getStoragePath() async {
    Directory? tempDir;
    if (Platform.isIOS) {
      tempDir = await getApplicationDocumentsDirectory();
    } else {
      tempDir = await getExternalStorageDirectory();
    }
    final filePath = Directory("${tempDir!.path}/files");
    if (await filePath.exists()) {
      return filePath.path;
    } else {
      await filePath.create(recursive: true);
      return filePath.path;
    }
  }
}
