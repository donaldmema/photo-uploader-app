import 'dart:convert';
import 'dart:io' as Io;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: UploadPage(),
  ));
}

class UploadPage extends StatefulWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  _UploadPageState createState() => _UploadPageState();
}

//hoverColor inkwell
class _UploadPageState extends State<UploadPage> {
  XFile? _imagePath;
  final ImagePicker picker = ImagePicker();

  Future<void> takePhoto() async {
    XFile? imageFromCamera = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imagePath = imageFromCamera;
    });
  }

  Future<void> pickPhotoFromGallery() async {
    XFile? imageFromGallery =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagePath = imageFromGallery;
    });
  }

  clear() {
    _imagePath == null;
  }

  void _uploadFile() async {
    // TODO: add exception check
    final List<int> imageAsBytes =
        Io.File(_imagePath!.path.toString()).readAsBytesSync();

    String base64Image = base64Encode(imageAsBytes);

    String fileName = _imagePath!.path.split('/').last;

    await http
        .post(Uri.parse('http://10.0.2.2:3000/upload'),
            headers: {"Content-Type": "application/json"},
            body: json.encode(<String, String>{
              "image": base64Image,
              "name": fileName,
            }))
        .then((res) {
      print(res.body);
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 60),
                child: Container(
                  width: 350,
                  height: 250,
                  color: Colors.transparent,
                  child: _imagePath == null
                      ? Center(
                          child: Text(
                            'NO IMAGE',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Image.file(
                          Io.File(_imagePath!.path),
                        ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          takePhoto();
                        },
                        //child: Row()
                        child: Container(
                          height: 55,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.tealAccent[700],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text('Take a photo'),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        highlightColor: Colors.amber,
                        onTap: () {
                          pickPhotoFromGallery();
                        },
                        child: Container(
                          height: 55,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.tealAccent[700],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text('Choose from Gallery'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              /* Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  highlightColor: Colors.amber,
                  onTap: () {
                    clear();
                  },
                  child: Container(
                    height: 55,
                    width: 196,
                    decoration: BoxDecoration(
                      color: Colors.tealAccent[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text('Clear'),
                    ),
                  ),
                ),
              ),
               */
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () => _uploadFile(),
                  child: Container(
                    height: 55,
                    width: 196,
                    decoration: BoxDecoration(
                      color: Colors.tealAccent[700],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text('Upload'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
