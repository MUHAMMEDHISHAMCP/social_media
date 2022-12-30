import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jsc_task2/providers/auth_provider.dart';
import 'package:jsc_task2/screens/login_screen.dart';
import 'package:jsc_task2/screens/widgets/snack_bar.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';
import 'package:jsc_task2/utils/box_dec.dart';

import 'package:jsc_task2/utils/const_color.dart';
import 'package:jsc_task2/utils/const_size.dart';
import 'package:jsc_task2/screens/widgets/text_field_widget.dart';
import 'package:jsc_task2/utils/pick_image.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final userNameController = TextEditingController();

  final passworsController = TextEditingController();

  final confirmPassworsController = TextEditingController();
  bool isLoading = false;

  Uint8List? profileImage;

  @override
  void dispose() {
    emailController.clear();
    super.dispose();
  }

  // Future<void> userSignUp() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   String result = await AuthMethods()
  //       .signUpUser(emailController.text, passworsController.text,confirmPassworsController.text,userNameController.text, profileImage!,context);

  //   if (result != 'Success') {
  //     ShowDialogs.popUp("Something went worng");
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  void slectImage() async {
    Uint8List pickedImage = await PickImage.pickImage(ImageSource.gallery);
    setState(() {
      profileImage = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDeco.containerBoxDecoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 6,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        profileImage != null
                            ? CircleAvatar(
                                radius: 60,
                                backgroundImage: MemoryImage(profileImage!),
                              )
                            : GestureDetector(
                                onTap: () {
                                  slectImage();
                                },
                                child: const CircleAvatar(
                                  radius: 60,
                                  backgroundColor: kBlack,
                                  backgroundImage:
                                      AssetImage('assets/dummy_profile.png'),
                                ),
                              ),
                        Positioned(
                            bottom: 0,
                            right: -7,
                            child: IconButton(
                                onPressed: () {
                                  slectImage();
                                },
                                icon: const Icon(
                                  Icons.add_a_photo_outlined,
                                  color: kBlack,
                                  size: 30,
                                ))),
                      ],
                    ),
                    kHeight15,
                    TextInputWidget(
                      hintText: 'UserName',
                      controller: userNameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter a Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    kheight10,
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
                    TextInputWidget(
                      isObsure: true,
                      hintText: 'Password',
                      controller: passworsController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter password';
                        } else {
                          return null;
                        }
                      },
                    ),
                    kheight10,
                    TextInputWidget(
                      isObsure: true,
                      hintText: 'Confirm Password',
                      controller: confirmPassworsController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Confirm password';
                        } else {
                          return null;
                        }
                      },
                    ),
                    kHeight20,
                    SizedBox(
                      width: 220,
                      height: 50,
                      child: Consumer<AuthProvider>(
                        builder: (context, value, child) => ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (profileImage == null) {
                                return ShowDialogs.popUp('Add Profile');
                              }

                              value.userSignUp(
                                  emailController.text,
                                  passworsController.text,
                                  confirmPassworsController.text,
                                  userNameController.text,
                                  profileImage!,
                                  context);
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
                  builder: (context) => LogInScreen(),
                ),
              );
            },
            child: Visibility(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  TextWidget(
                    text: 'ALREADY HAVE AN ACCOUNT?',
                    fontSize: 16,
                    color: subColor,
                    weight: FontWeight.bold,
                  ),
                  kwidth10,
                  TextWidget(
                    text: 'Sign In',
                    fontSize: 16,
                    color: subColor,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
