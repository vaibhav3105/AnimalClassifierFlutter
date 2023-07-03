import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isloading = false;
  final picker = ImagePicker();
  XFile? _imageFile;
  var prediction = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // predict();
  }

  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile;
    });
    if (pickedFile != null) {
      predict();
    }
  }

  predict() async {
    setState(() {
      isloading = true;
    });
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/predict'));
    // var picture = http.MultipartFile.fromBytes('file',
    //     (await rootBundle.load('assets/snake.jpg')).buffer.asUint8List(),
    //     filename: 'test_image');
    var picture = await http.MultipartFile.fromPath('file', _imageFile!.path);

    request.files.add(picture);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var result = String.fromCharCodes(responseData);
    var parsedResult = jsonDecode(result);
    print(result);
    setState(() {
      isloading = false;
      prediction = parsedResult;
    });
    return result;
    // http.Response response =
    //     await http.get(Uri.parse('http://10.0.2.2:8000/ping'));
    // var result = response.body;
    // print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: pickImage,
                      child: const Text("Pick Image from gallery")),
                  // ElevatedButton(
                  //     onPressed: predict, child: const Text("Predict")),
                  if (_imageFile != null)
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.file(File(_imageFile!.path)),
                    ),
                  if (prediction.isNotEmpty)
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: FileImage(File(_imageFile!.path)),
                          // child: Image.file(
                          //   File(_imageFile!.path),
                          //   fit: BoxFit.contain,
                          // ),
                        ),
                        title: const Text("Predicted Animal"),
                        subtitle: Text(prediction['predicted_class']),
                      ),
                    ),
                  const Divider(),
                  if (prediction.isNotEmpty)
                    Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: FileImage(File(_imageFile!.path)),
                          // child: Image.file(
                          //   File(_imageFile!.path),
                          //   fit: BoxFit.contain,
                          // ),
                        ),
                        title: const Text("Model Confidence"),
                        subtitle: Text(prediction['confidence']),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
