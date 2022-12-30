import 'package:flutter/material.dart';
import 'package:jsc_task2/providers/auth_provider.dart';
import 'package:jsc_task2/screens/sign_up_screen.dart';
import 'package:jsc_task2/utils/box_dec.dart';
import 'package:jsc_task2/utils/const_color.dart';

import 'package:jsc_task2/utils/const_size.dart';
import 'package:jsc_task2/screens/widgets/text_field_widget.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({Key? key}) : super(key: key);

  final emailController = TextEditingController();

  final passworsController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  // Future<void> userLogIn() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   String result = await AuthMethods()
  //       .signInUser(emailController.text, passworsController.text, context);

  //   if (result != "Success") {
  //     ShowDialogs.popUp("Email and Password dosen't match");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDeco.containerBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: const [
                    TextWidget(
                      text: 'Welcome Back',
                      fontSize: 25,
                      weight: FontWeight.bold,
                    ),
                    kHeight5,
                    TextWidget(
                      text: 'Login to Your Account',
                      fontSize: 18,
                      weight: FontWeight.w300,
                    )
                  ],
                ),
                kHeight30,
                TextInputWidget(
                  hintText: 'E-mail',
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter email';
                    } else {
                      return null;
                    }
                  },
                ),
                kheight10,
                Consumer<AuthProvider>(
                  builder: (context, value, child) => TextInputWidget(
                    hintText: 'Password',
                    controller: passworsController,
                    isObsure: value.isObscure,
                    icon: IconButton(
                        onPressed: () {
                          value.isObscure = !value.isObscure;
                        },
                        icon: Icon(value.isObscure
                            ? Icons.visibility_off
                            : Icons.visibility)),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter password';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                kHeight20,
                SizedBox(
                  width: 220,
                  height: 50,
                  child: Consumer<AuthProvider>(
                    builder: (context, value, child) => ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          value.userLogIn(emailController.text,
                              passworsController.text, context);
                        }
                      },
                      // style: ElevatedButton.styleFrom(
                      //     backgroundColor: const Color(0xff134CB5)),
                      child: value.isLoading == true
                          ? const CircularProgressIndicator(
                              color: subColor,
                              strokeWidth: 2,
                            )
                          : const Text('Sign Up'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomSheet: Container(
          color: mainColor,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                TextWidget(
                  text: 'DONT HAVE AN ACCOUNT?',
                  fontSize: 16,
                  color: subColor,
                  weight: FontWeight.bold,
                ),
                kwidth10,
                TextWidget(
                  text: 'Sign Up',
                  fontSize: 16,
                  color: subColor,
                  weight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
