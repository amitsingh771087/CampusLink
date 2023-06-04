import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CreateProfilePage extends StatefulWidget {
  final String username;
  final String uuid;
  final String fullName;
  final String className;
  final String div;

  CreateProfilePage({
    required this.username,
    required this.uuid,
    required this.fullName,
    required this.className,
    required this.div,
  });

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  File? _imageFile;
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _securityAnswerController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  String _selectedGender = '';

  bool _obscureText = true;
  bool _obscureConfirmText = true;

  Future<void> _getImage(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.getImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText;
    });
  }

  void _uploadImage() {
  if (_imageFile == null) {
    showAlertDialog(context, 'Please select an image.');
    return;
  }
  try {
    // Convert image file to base64
    String base64Image = base64Encode(_imageFile!.readAsBytesSync());
   // img.Image resizedImage = img.copyResize(base64Image!, width: 725, height: 725);

    int maxSizeInBytes = 500 * 1024; // 500KB
    int fileSizeInBytes = _imageFile!.lengthSync();
    if (fileSizeInBytes > maxSizeInBytes) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Image Size Exceeded'),
            content: Text('The selected image is too large. Maximum size allowed is 500 kb .'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

      return;
    }

    // Make API request with the base64Image
    _registerUser(base64Image);
  } catch (e) {
    print('Error encoding image to base64: $e');
    showAlertDialog(context, 'Failed to encode image. Please try again.');
  }
}

  void _registerUser(String profilePic) async {
    // API endpoint
    String apiUrl = 'https://campuslinkbackend.onrender.com/api/user/';

    // Create the request body
    Map<String, dynamic> requestBody = {
      "UUID": widget.uuid,
      "username": widget.username,
      "fullname": widget.fullName,
      "password": _passwordController.text.trim(),
      "Class": widget.className,
      "div": widget.div,
      "securityQ": "what color is your bugatti",
      "securityA": _securityAnswerController.text.trim(),
      "avatar_id": "kjbsdfauik;",
      "phoneNumber": _phoneNumberController.text.trim(),
      "gender": _selectedGender,
      "age":_ageController.text.trim(),
      "isAlumini": false,
      "bio": "hey its me",
      // profilePic
      // int.tryParse(_ageController.text) ?? 0
    };

    // Convert the request body to JSON
    String jsonBody = jsonEncode(requestBody);

    // Make a POST request to the API
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      // Registration successful
      showAlertDialog(context, 'Failed to register user. Please try again.');
    } else {
      // Registration failed
      String errorMessage = 'User registered successfully.' ;
      try {
        String responseBody = response.body;
        print('Response body: $responseBody'); // Print the response body for debugging

        if (response.headers['content-type']?.contains('text/html') == true) {
          // Response is of type HTML, handle accordingly
          errorMessage = 'Unexpected response from the server.';
        } else {
          // Attempt to parse JSON error message
          var responseData = jsonDecode(responseBody);
          if (responseData != null && responseData is Map && responseData['message'] != null) {
            errorMessage = responseData['message'];
          }
        }
      } catch (e) {
        print('Error parsing error message: $e');
      }
      showAlertDialog(context, errorMessage);
      print('Registration failed: $errorMessage');
    }
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registration'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _securityAnswerController.dispose();
    _phoneNumberController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
      ),
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16.0),
              Center(
                child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('Take a photo'),
                                onTap: () {
                                  _getImage(ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Choose from gallery'),
                                onTap: () {
                                  _getImage(ImageSource.gallery);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null ? Icon(Icons.camera_alt, size: 60) : null,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Username: ${widget.username}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _passwordController,
                obscureText: _obscureText,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                    onPressed: _togglePasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmText,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmText ? Icons.visibility : Icons.visibility_off),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _securityAnswerController,
                decoration: InputDecoration(
                  labelText: 'Security Answer',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Gender',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: 'male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio<String>(
                    value: 'female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Female'),
                  Radio<String>(
                    value: 'non-binary',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  Text('Other'),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CreateProfilePage(
      username: 'JohnDoe',
      uuid: '1234567890',
      fullName: 'John Doe',
      className: '10A',
      div: 'A',
    ),
  ));
}
