import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ClassificationService {
  static final _picker = ImagePicker();

  static Future<File> pickImage() async {
    var pickedFile = await _picker.pickImage(source: ImageSource.camera);
    return File(pickedFile!.path);
  }

  static Future<File> pickGalleryImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    // if(image == null)
    return File(image!.path);
  }
}
