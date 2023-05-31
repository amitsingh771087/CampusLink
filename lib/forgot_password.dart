import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Forgot Your Password?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(
              height: 40.0,
            ),

            TextFormField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(
              height: 20.0,
            ),

            ElevatedButton(
              onPressed: () {
                // TODO: Implement Forgot Password functionality
                print('Forgot Password');
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
