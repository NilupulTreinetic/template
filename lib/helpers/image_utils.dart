import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageUtils {
  static final ImageUtils _singleton = ImageUtils._internal();

  factory ImageUtils() {
    return _singleton;
  }

  ImageUtils._internal();

  Future<String?> cropImage(String path) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop your image',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.white,
            activeControlsWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            statusBarColor: Colors.white,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop your image',
        ),
      ],
    );
    if (croppedFile != null) {
      return croppedFile.path;
    }
    return null;
  }

  Future<List<XFile?>> pickImageList() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile?> imageList = await picker.pickMultiImage();
      if (imageList.isNotEmpty) {
        return imageList;
      }
    } catch (e) {
      rethrow;
    }
    return [];
  }

  Future<XFile?> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      if (await Permission.camera.request().isGranted) {
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          return image;
        }
      } else {
        openAppSettings();
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<File> compressFile(File file, {int quality = 70}) async {
    try {
      File compressedFile = await FlutterNativeImage.compressImage(
        file.path,
        quality: quality,
      );
      //return compressedFile.absolute.path;
      return compressedFile;
    } catch (e) {
      return file;
    }
  }
}
