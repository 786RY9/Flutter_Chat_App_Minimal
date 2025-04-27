import 'package:chat_app_minimal/services/auth/auth_service.dart';
import 'package:chat_app_minimal/components/my_button.dart';
import 'package:chat_app_minimal/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key,required this.onTap});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  // void login function for button
  void login(BuildContext context) async{
 final authService = AuthService();
    try{
     await authService.signInWithEmailPassword(_emailController.text, _pwController.text);
    }
    catch(e){
      // ignore: use_build_context_synchronously
      showDialog(context: context, builder:(context)=> AlertDialog(
        title: Text(e.toString())
      ));
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
              "Welcom back, you've been missed!",
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
            // login button
            MyButton(text: 'Login', onTap: ()=>login(context)),

            // register now
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member? ',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Register now',
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
