import 'package:flutter/material.dart';

void main() {
  runApp(RegisterApp());
}

class RegisterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  SizedBox(height: 50.0),
                  Image.asset(
                    'assets/logo.png', // Replace with your logo image path
                    width: 150.0,
                    height: 150.0,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'UUID',
              ),
            ),
            SizedBox(height: 16.0),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: () {
                  // Functionality for verify user
                },
                child: Text('Verify User'),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Class',
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Division',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Functionality for register user
              },
              child: Text('Register User'),
            ),
          ],
        ),
      ),
    );
  }
}