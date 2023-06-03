import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  File? _image;
  final picker = ImagePicker();
  TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> openCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> openGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  String _imageToBase64(img.Image image) {
    // Encode the image to JPEG format
    List<int> jpgBytes = img.encodeJpg(image, quality: 100);

    // Convert List<int> to Uint8List
    Uint8List uint8List = Uint8List.fromList(jpgBytes);

    // Encode the JPEG bytes to base64
    String base64Image = base64Encode(uint8List);

    return base64Image;
  }

  Future<void> uploadImage(File imageFile) async {
    String fileName = imageFile.path.split('/').last;
    String caption = _captionController.text;

    // Read the image file
    img.Image? decodedImage = img.decodeImage(imageFile.readAsBytesSync());

    // Resize the image if needed
    img.Image resizedImage = img.copyResize(decodedImage!, width: 500, height: 500);

    // Convert the image to base64
    String base64Image = _imageToBase64(resizedImage);

    Map<String, dynamic> requestBody = {
      "Image": base64Image,
      "Caption": caption,
      "UUID": "2121179",
      "Date": "31-5-2023",
      "Num_likes": "132",
      "Time": "16:41",
      "Comment_id": "64701212231284d6c890234210"
    };

    // Convert to JSON payload
    String jsonBody = jsonEncode(requestBody);

    try {
      var response = await http.post(
        Uri.parse('https://campuslinkbackendpost.onrender.com/api/post'),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        Fluttertoast.showToast(
          msg: 'Image uploaded successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // TODO: Handle success message or navigation after successful upload
      } else {
        print('Failed to upload image: ${response.statusCode}');
        print('Bodyresp ${response.body}');

        Fluttertoast.showToast(
          msg: 'Failed to upload image',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        // TODO: Handle error message or retry logic
      }
    } catch (e) {
      print('Error uploading image: $e');
      // TODO: Handle error message or retry logic
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 200.0,
                child: _image != null
                    ? Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      )
                    : Icon(Icons.image, size: 80),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: openCamera,
                    child: Text('Take Photo'),
                  ),
                  ElevatedButton(
                    onPressed: openGallery,
                    child: Text('Upload from Gallery'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _captionController,
                decoration: InputDecoration(
                  labelText: 'Caption',
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_image != null) {
                    uploadImage(_image!);
                  } else {
                    // TODO: Show error message if no image is selected
                  }
                },
                child: Text('Upload Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
