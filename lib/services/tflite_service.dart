import 'dart:async';
import 'dart:io';
import 'package:iwdpets/models/tflite_model.dart';
import 'package:tflite/tflite.dart';

class TfLiteService {
  static Future loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
  }

  static void dispose() {
    Tflite.close();
  }

  static Future<List<TfLiteModel>> classifyImage(File image) async {
    List<TfLiteModel> outputs = [];
    var output = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );

    output?.forEach((value) {
      final element = TfLiteModel.fromModel(value);
      outputs.add(element);
    });

    print(outputs);

    return outputs;
  }
}
