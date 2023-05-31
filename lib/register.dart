import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    super.dispose();
  }

  Future<bool> validateUUID(String uuid) async {
    // API endpoint
    String apiUrl = 'https://campuslinkbackend.onrender.com/api/user/verifyUser/$uuid';

    // Make a GET request to the API
    var response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // UUID verification successful
      return true;
    } else {
      // UUID verification failed
      return false;
    }
  }

  void showAlertDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('UUID Validation'),
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

  void register() async {
    String fullName = _fullNameController.text.trim();
    String uuid = _uuidController.text.trim();
    String className = _classController.text.trim();
    String div = _divController.text.trim();

    if (fullName.isEmpty || uuid.isEmpty || className.isEmpty || div.isEmpty) {
      showAlertDialog(context, 'All fields are required');
      return;
    }

    bool isValidUUID = await validateUUID(uuid);

    if (isValidUUID) {
      showAlertDialog(context, 'User is from our campus');
    } else {
      showAlertDialog(context, 'User is not from our campus');
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
              Text(
                'Register',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
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
            ],
          ),
        ),
      ),
    );
  }
}
