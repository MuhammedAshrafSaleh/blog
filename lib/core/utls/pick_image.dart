import 'dart:io';
import 'package:image_picker/image_picker.dart';

Future<File?> pickGallaryImage() async {
  try {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<File?> pickCameraImage() async {
  try {
    final xFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxHeight: 400,
      maxWidth: 400,
    );
    if (xFile != null) {
      return File(xFile.path);
    }
    return null;
  } catch (e) {
    return null;
  }
}
