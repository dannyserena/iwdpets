import 'dart:io';

import 'package:flutter/material.dart';
import 'package:iwdpets/models/tflite_model.dart';
import 'package:iwdpets/services/classification_service.dart';
import 'package:iwdpets/services/tflite_service.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//   final bool _loading = true;
  File? _image;
  List<TfLiteModel> _outputs = [];

  @override
  void initState() {
    super.initState();
    TfLiteService.loadModel();
  }

  @override
  void dispose() {
    TfLiteService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('WTM Flutter + Machine Learn'),
      ),
      body: SafeArea(
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildLogo(),
              _buildResult(),
              _buildImage(),
              _buildButtons(),
            ]),
      ),
    );
  }

  _buildButtons() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Camera ')),
          ElevatedButton.icon(
              onPressed: _pickGalleryImage,
              icon: const Icon(Icons.image),
              label: const Text('Galeria '))
        ]);
  }

  _buildLogo() {
    return Expanded(
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Image.asset('assets/qual_pet.png'),
          ],
        ),
      ),
    );
  }

  _buildImage() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 92.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.cyan,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: _image == null
                ? const Text('Pra comecar, vamos scanear uma imagem?')
                : Image.file(
                    _image!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  _pickImage() async {
    final image = await ClassificationService.pickImage();
    if (image == null) {
      return null;
    }

    final outputs = await TfLiteService.classifyImage(image);

    setState(() {
      _image = image;
      _outputs = outputs;
    });
  }

  _pickGalleryImage() async {
    var image = await ClassificationService.pickGalleryImage();
    if (image == null) return null;
    final outputsGalery = await TfLiteService.classifyImage(image);

    setState(() {
      _image = image;
      _outputs = outputsGalery;
    });
  }

  _buildResult() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Container(
        height: 80.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.cyan,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _buildResultList(),
      ),
    );
  }

  _buildResultList() {
    if (_outputs.isEmpty) {
      return const Center(
        child: Text('Não houve análise'),
      );
    }

    return Center(
      child: ListView.builder(
        itemCount: _outputs.length,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              Text(
                '${_outputs[index].label}( ${(_outputs[index].confidence! * 100.0).toStringAsFixed(1)} % )',
              ),
              const SizedBox(
                height: 10.0,
              ),
              LinearPercentIndicator(
                lineHeight: 16.0,
                percent: _outputs[index].confidence!,
              ),
            ],
          );
        },
      ),
    );
  }
}
