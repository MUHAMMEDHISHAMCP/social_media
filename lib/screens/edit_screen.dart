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

class EditScreen extends StatefulWidget {
   EditScreen({Key? key,required this.profileImage,required this.userName}) : super(key: key);
  String profileImage;
  String userName;
  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final userNameController = TextEditingController();

  final passworsController = TextEditingController();

  final confirmPassworsController = TextEditingController();
  bool isLoading = false;

  String? profileImage;

  Uint8List? updatedImage;

@override
  void initState() {
   profileImage = widget.profileImage;
   userNameController.text = widget.userName;
    super.initState();
  }


  @override
  void dispose() {
    emailController.clear();
    super.dispose();
  }



  void slectImage() async {
    Uint8List pickedImage = await PickImage.pickImage(ImageSource.gallery);
    setState(() {
      updatedImage = pickedImage;
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    profileImage != null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(profileImage!),
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
                  hintText: 'Adress',
                  controller: emailController,
         
                ),
                kheight10,
                TextInputWidget(
                  hintText: 'Place',
                  controller: passworsController,
         
                ),
                kheight10,
                // TextInputWidget(
                //   hintText: 'Confirm Password',
                //   controller: confirmPassworsController,
                //   validator: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please Confirm password';
                //     } else {
                //       return null;
                //     }
                //   },
                // ),
                kHeight20,
                SizedBox(
                  width: 220,
                  height: 50,
                  child: Consumer<AuthProvider>(
                    builder: (context, value, child) => 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                               

                               Navigator.of(context).pop();
                                    //  value.userSignUp(
                                    //     emailController.text,
                                    //     passworsController.text,
                                    //     confirmPassworsController.text,
                                    //     userNameController.text,
                                    //     profileImage!,
                                    //     context);
                                  }
                                },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: backgroundColor,),
                                child:const Text('Cancel'),
                              ),
                               ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                               

                               Navigator.of(context).pop();
                                    //  value.userSignUp(
                                    //     emailController.text,
                                    //     passworsController.text,
                                    //     confirmPassworsController.text,
                                    //     userNameController.text,
                                    //     profileImage!,
                                    //     context);
                                  }
                                },
                           
                                child:const Text('Update'),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
   
      ),
    );
  }
}
