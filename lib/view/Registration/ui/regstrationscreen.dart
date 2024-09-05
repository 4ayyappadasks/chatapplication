import 'package:chatapplication/auth/apis.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
          onPressed: () {
            Apis.registerWithEmailAndPassword(
                "jiji@gmail.com", "password", "displayName");
          },
          child: Text("data")),
    );
  }
}
