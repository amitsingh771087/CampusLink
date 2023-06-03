import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'create_profile.dart';
import 'login.dart'; // Import the login.dart file

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _uuidController = TextEditingController();
  TextEditingController _classController = TextEditingController();
  TextEditingController _divController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = _animationController;
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fullNameController.dispose();
    _uuidController.dispose();
    _classController.dispose();
    _divController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<bool> validateUUIDAndUsername(String uuid, String username) async {
    // API endpoint
    String apiUrl = 'https://campuslinkbackend.onrender.com/api/user/verifyUser/$uuid/$username';

    // Make a GET request to the API
    var response = await http.get(Uri.parse(apiUrl));
    var data = json.decode(response.body);
    var message = data['message'];

    if (message == 'true') {
      // UUID and username verification successful
      return true;
    } else {
      // UUID and username verification failed
      return false;
    }
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Validation'),
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

  void navigateToCreateProfile(String fullName, String uuid, String className, String div, String username) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateProfilePage(
          uuid: uuid,
          fullName: fullName,
          className: className,
          div: div,
          username: username,
        ),
      ),
    );
  }

  void register() async {
    String fullName = _fullNameController.text.trim();
    String uuid = _uuidController.text.trim();
    String className = _classController.text.trim();
    String div = _divController.text.trim();
    String username = _usernameController.text.trim();

    if (fullName.isEmpty || uuid.isEmpty || className.isEmpty || div.isEmpty || username.isEmpty) {
      showAlertDialog(context, 'All fields are required');
      return;
    }

    bool isValidUUIDAndUsername = await validateUUIDAndUsername(uuid, username);

    if (isValidUUIDAndUsername) {
      navigateToCreateProfile(fullName, uuid, className, div, username);
    } else {
      showAlertDialog(context, 'UUID or Username is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        color: Color(0xFF7588EF),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(
                size: 100.0,
              ),
              SizedBox(height: 24.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _uuidController,
                  decoration: InputDecoration(
                    labelText: 'UUID',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextField(
                        controller: _classController,
                        decoration: InputDecoration(
                          labelText: 'Class',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: TextField(
                        controller: _divController,
                        decoration: InputDecoration(
                          labelText: 'Div',
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: register,
                child: Text('Register'),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                  );
                },
                child: Text(
                  'Already have an Account? Login',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
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
