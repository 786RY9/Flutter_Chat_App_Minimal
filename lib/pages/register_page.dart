import 'package:chat_app_minimal/services/auth/auth_service.dart';
import 'package:chat_app_minimal/components/my_button.dart';
import 'package:chat_app_minimal/components/my_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTap});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwConfirmController = TextEditingController();

  void register(BuildContext context) {
    final _auth = AuthService();

    if (_pwController.text == _pwConfirmController.text) {
      try {
        _auth.signupWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } on FirebaseAuthException catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text(e.toString())),
        );
      }
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(title: Text("Passwords don't match!")),
      );
    }
  }

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),

            const SizedBox(height: 50),

            // welcome back message
            Text(
              "Let's create an account for you!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),

            // email textfield
            MyTextfield(
              hintText: 'Email',
              obscure: false,
              controller: _emailController,
            ),
            SizedBox(height: 10),

            // pw textfield
            MyTextfield(
              hintText: 'Password',
              obscure: true,
              controller: _pwController,
            ),
            SizedBox(height: 25),
            MyTextfield(
              hintText: 'Confirm Password',
              obscure: true,
              controller: _pwConfirmController,
            ),
            SizedBox(height: 25),
            // login button
            MyButton(text: 'Register', onTap: () => register(context)),

            // register now
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
