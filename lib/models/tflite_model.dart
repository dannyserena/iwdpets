class TfLiteModel {
  double? confidence;
  int? id;
  String? label;

  TfLiteModel(this.confidence, this.id, this.label);

  TfLiteModel.fromModel(dynamic model) {
    confidence = model['confidence'];
    id = model['index'];
    label = model['label'];
  }
}
