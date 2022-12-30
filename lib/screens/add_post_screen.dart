import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jsc_task2/model/user.dart';
import 'package:jsc_task2/providers/post_provider.dart';
import 'package:jsc_task2/providers/user_provider.dart';
import 'package:jsc_task2/screens/widgets/snack_bar.dart';
import 'package:jsc_task2/utils/box_dec.dart';
import 'package:jsc_task2/utils/const_color.dart';
import 'package:jsc_task2/utils/const_size.dart';
import 'package:jsc_task2/screens/widgets/text_widget.dart';
import 'package:jsc_task2/utils/pick_image.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final descriptionController = TextEditingController();
  Uint8List? postImage;
  void slectImage() async {
    Uint8List pickedImage = await PickImage.pickImage(ImageSource.gallery);
    setState(() {
      postImage = pickedImage;
    });
  }

  Future<void> getUserDetails() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUserDetails();
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    UserData? userDetails = Provider.of<UserProvider>(context).getUser;
    final prov = Provider.of<PostProvider>(
      context,
    );
    return Container(
      decoration: BoxDeco.containerBoxDecoration(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const TextWidget(
              text: 'Add Post',
              fontSize: 20,
              color: subColor,
              weight: FontWeight.bold,
            ),
            centerTitle: true,
            backgroundColor: mainColor,
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Center(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  prov.isLoading == true
                      ? const LinearProgressIndicator(
                          color: mainColor,
                          backgroundColor: subColor,
                        )
                      : const SizedBox(),
                  kHeight20,
                  postImage == null
                      ? GestureDetector(
                          onTap: () {
                            //  showDialog(
                            //     context: context,
                            //     builder: (ctx) {
                            //       return  AddPopup(postImage: postImage!,);
                            //     });
                            slectImage();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 3,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black45,
                                  style: BorderStyle.solid),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_box_rounded),
                                  TextWidget(
                                    text: "Add Image",
                                    fontSize: 20,
                                    weight: FontWeight.w400,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height / 3,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(
                                postImage!,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                  kHeight5,
                  ElevatedButton(
                      onPressed: () {
                        // showDialog(
                        //     context: context,
                        //     builder: (ctx) {
                        //       return  AddPopup(postImage: postImage!,);
                        //     });
                        slectImage();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.5)),
                      child: const TextWidget(
                        text: "Add Image",
                        fontSize: 16,
                        weight: FontWeight.bold,
                      )),
                  kheight10,
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      counterText: '',
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  kheight10,
                  Consumer<PostProvider>(
                    builder: (context, value, child) => Visibility(
                      visible: !value.isLoading,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (postImage == null) {
                              ShowDialogs.popUp('Add Image');
                            }
                            await value.postImage(
                              postImage!,
                              userDetails!.uid,
                              userDetails.imageUrl,
                              userDetails.userName,
                              descriptionController.text,
                            );
                            postImage = null;
                            descriptionController.clear();
                          },
                          child: const TextWidget(
                            text: "Add Your Post",
                            fontSize: 16,
                            weight: FontWeight.bold,
                          )),
                    ),
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
